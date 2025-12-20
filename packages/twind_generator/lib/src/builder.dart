import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:twind/twind.dart';

/// Builds generators for the `@Tw()` annotation.
Builder twindBuilder(BuilderOptions options) {
  return SharedPartBuilder([_TwindGenerator()], 'twind');
}

typedef Methods = List<(MethodElement, String)>;
typedef Classes = List<(ClassElement, Methods)>;

class _TwindGenerator extends Generator {
  static final _twindAnnoationChecker = TypeChecker.typeNamed(Tw);

  static final _widgetChecker = TypeChecker.fromUrl(
    'package:flutter/src/widgets/framework.dart#Widget',
  );

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final Classes classes = [];
    for (final classElement in library.classes) {
      final Methods methods = [];
      for (final method in classElement.methods) {
        final annotations = _twindAnnoationChecker.annotationsOfExact(method);
        if (annotations.isEmpty) continue;
        _validateTwindMethod(method);

        final joinedClasses = <String>[];
        for (final annotation in annotations) {
          final classes = ConstantReader(
            annotation,
          ).read('className').stringValue;
          joinedClasses.add(classes);
        }
        methods.add((method, joinedClasses.join(' ')));
      }
      if (methods.isEmpty) continue;
      classes.add((classElement, methods));
    }

    if (classes.isEmpty) return null;

    final output = StringBuffer();
    for (final (cls, methods) in classes) {
      output.writeln('mixin _\$${cls.displayName} {');
      for (final (method, className) in methods) {
        final signature = method.displayString();
        final _ = className;
        output.writeln('  $signature {');
        output.writeln('    return child;');
        output.writeln('  }');
      }
      output.writeln('}');
    }

    return output.toString();
  }

  void _validateTwindMethod(MethodElement method) {
    if (!method.isAbstract) {
      throw InvalidGenerationSourceError(
        '`@Tw()` methods must not have a body.',
        element: method,
      );
    }

    if (!_widgetChecker.isAssignableFromType(method.returnType)) {
      throw InvalidGenerationSourceError(
        '`@Tw()` methods must return a Widget.',
        element: method,
      );
    }

    var hadChildParam = false;
    for (final parameter in method.formalParameters) {
      if (parameter.name == 'child') {
        final isNullable = parameter.type.nullabilitySuffix != .none;
        if (!parameter.isRequired || parameter.isOptional || isNullable) {
          throw InvalidGenerationSourceError(
            '`@Tw()` child parameter must be required.',
            element: method,
          );
        }
        if (!_widgetChecker.isAssignableFromType(parameter.type)) {
          throw InvalidGenerationSourceError(
            '`@Tw()` child parameter must be a Widget.',
            element: method,
          );
        }
        hadChildParam = true;
        break;
      }
    }

    if (!hadChildParam) {
      throw InvalidGenerationSourceError(
        '`@Tw()` methods must have a required `child` parameter of type Widget.',
        element: method,
      );
    }
  }
}
