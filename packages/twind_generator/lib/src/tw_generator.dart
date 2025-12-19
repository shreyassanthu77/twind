import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:twind/twind.dart';

final _twChecker = TypeChecker.fromRuntime(Tw);

class _AnnotatedMethod {
  final MethodElement method;
  final String className;

  _AnnotatedMethod({required this.method, required this.className});
}

/// Generator for the `@Tw()` annotation.
///
/// This generator looks for `@Tw('...')` annotations on abstract methods inside
/// a class and emits a `mixin _$<ClassName>` that implements those methods.
class TwGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final methodsByClass = <InterfaceElement, List<_AnnotatedMethod>>{};

    for (final classElement in library.classes) {
      for (final method in classElement.methods) {
        if (method.enclosingElement != classElement) continue;

        final annotation = _twChecker.firstAnnotationOf(
          method,
          throwOnUnresolved: false,
        );
        if (annotation == null) continue;

        if (!method.isAbstract) {
          throw InvalidGenerationSourceError(
            '`@Tw()` methods must be abstract (no body).',
            element: method,
          );
        }

        final reader = ConstantReader(annotation);
        final classes = reader.read('className').stringValue;

        methodsByClass
            .putIfAbsent(classElement, () => <_AnnotatedMethod>[])
            .add(_AnnotatedMethod(method: method, className: classes));
      }
    }

    if (methodsByClass.isEmpty) return '';

    final output = StringBuffer();
    output.writeln('// ignore_for_file: unused_element');
    for (final entry in methodsByClass.entries) {
      final classElement = entry.key;
      final annotatedMethods = entry.value;

      output.writeln('mixin _\$${classElement.displayName} {');
      for (final annotated in annotatedMethods) {
        output.writeln(_generateMethod(annotated.method, annotated.className));
      }
      output.writeln('}');
    }

    return output.toString();
  }

  String _generateMethod(MethodElement method, String classes) {
    final childParam = method.parameters.where((p) => p.name == 'child');
    if (childParam.isEmpty) {
      throw InvalidGenerationSourceError(
        '`@Tw()` methods must have a named parameter `child`.',
        element: method,
      );
    }

    if (method.parameters.length != 1) {
      throw InvalidGenerationSourceError(
        '`@Tw()` methods currently only support `{Widget? child}`.',
        element: method,
      );
    }

    final signature = _methodSignature(method);
    final widgetExpr = _buildWidgetExpression(classes.trim());

    return '  $signature {\n'
        '    return $widgetExpr;\n'
        '  }\n';
  }

  String _methodSignature(MethodElement method) {
    final returnType = method.returnType.getDisplayString(
      withNullability: true,
    );

    final params = method.parameters
        .map((param) {
          final type = param.type.getDisplayString(withNullability: true);

          final defaultValue = param.defaultValueCode;
          final defaultSuffix = defaultValue == null ? '' : ' = $defaultValue';

          if (param.isNamed) {
            final requiredPrefix = param.isRequiredNamed ? 'required ' : '';
            return '$requiredPrefix$type ${param.name}$defaultSuffix';
          }

          if (param.isRequiredPositional) {
            return '$type ${param.name}$defaultSuffix';
          }

          return '$type ${param.name}$defaultSuffix';
        })
        .join(', ');

    final paramList = '{ $params }';

    return '$returnType ${method.displayName}($paramList)';
  }

  String _buildWidgetExpression(String classes) {
    String expr = 'child ?? const SizedBox.shrink()';

    final utilities = classes.isEmpty
        ? const <String>[]
        : classes.split(RegExp(r'\s+'));

    double? horizontalPadding;
    double? verticalPadding;
    String? backgroundColor;

    for (final utility in utilities) {
      if (utility.startsWith('px-')) {
        horizontalPadding = _parseSpacing(utility.substring(3));
      } else if (utility.startsWith('py-')) {
        verticalPadding = _parseSpacing(utility.substring(3));
      } else if (utility.startsWith('p-')) {
        final value = _parseSpacing(utility.substring(2));
        horizontalPadding = value;
        verticalPadding = value;
      } else if (utility.startsWith('bg-')) {
        backgroundColor = _parseColorExpression(utility.substring(3));
      } else {
        throw InvalidGenerationSourceError(
          'Unsupported Tw utility: `$utility`.',
        );
      }
    }

    if (horizontalPadding != null || verticalPadding != null) {
      final h = horizontalPadding ?? 0;
      final v = verticalPadding ?? 0;
      expr =
          'Padding(\n'
          '      padding: EdgeInsets.symmetric(\n'
          '        horizontal: ${_formatDouble(h)},\n'
          '        vertical: ${_formatDouble(v)},\n'
          '      ),\n'
          '      child: $expr,\n'
          '    )';
    }

    if (backgroundColor != null) {
      expr =
          'DecoratedBox(\n'
          '      decoration: BoxDecoration(\n'
          '        color: $backgroundColor,\n'
          '        borderRadius: BorderRadius.circular(4),\n'
          '      ),\n'
          '      child: $expr,\n'
          '    )';
    }

    return expr;
  }

  double _parseSpacing(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null) {
      throw InvalidGenerationSourceError('Invalid spacing value: `$value`.');
    }

    // Intentionally simple scale (matches the current example).
    return parsed * 2;
  }

  String _parseColorExpression(String value) {
    final match = RegExp(
      r'^(?<name>[a-zA-Z]+)(-(?<shade>\d+))?$',
    ).firstMatch(value);

    if (match == null) {
      throw InvalidGenerationSourceError('Invalid color value: `$value`.');
    }

    final name = match.namedGroup('name')!;
    final shade = match.namedGroup('shade');

    final base = switch (name) {
      'red' => 'Colors.red',
      'blue' => 'Colors.blue',
      'green' => 'Colors.green',
      'yellow' => 'Colors.yellow',
      'orange' => 'Colors.orange',
      'purple' => 'Colors.purple',
      'pink' => 'Colors.pink',
      'teal' => 'Colors.teal',
      'indigo' => 'Colors.indigo',
      'gray' || 'grey' => 'Colors.grey',
      'black' => 'Colors.black',
      'white' => 'Colors.white',
      _ => throw InvalidGenerationSourceError(
        'Unsupported color name: `$name`.',
      ),
    };

    if (shade == null) return base;

    // Not all `Colors.*` have shades, but most Material colors do.
    return '$base.shade$shade';
  }

  String _formatDouble(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}
