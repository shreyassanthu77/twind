import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
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
  static final _twindAnnoationChecker = TypeChecker.fromRuntime(Tw);

  static bool _isFlutterWidgetType(DartType type) {
    if (type is! InterfaceType) return false;

    if (_isFlutterWidgetInterfaceType(type)) return true;
    for (final supertype in type.allSupertypes) {
      if (_isFlutterWidgetInterfaceType(supertype)) return true;
    }

    return false;
  }

  static bool _isFlutterWidgetInterfaceType(InterfaceType type) {
    final uri = type.element.librarySource.uri.toString();
    return type.element.name == 'Widget' && uri.startsWith('package:flutter/');
  }

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

    final output = StringBuffer();
    for (final (cls, methods) in classes) {
      output.writeln('mixin _\$${cls.displayName} {');
      // for (final (method, classes) in methods) {}
      output.writeln("}");
    }
  }

  void _validateTwindMethod(MethodElement method) {
    if (!method.isAbstract) {
      throw InvalidGenerationSourceError(
        '`@Tw()` methods must not have a body.',
        element: method,
      );
    }

    if (!_isFlutterWidgetType(method.returnType)) {
      throw InvalidGenerationSourceError(
        '`@Tw()` methods must return a Widget.',
        element: method,
      );
    }

    var hadChildParam = false;
    for (final parameter in method.parameters) {
      if (parameter.name == 'child') {
        if (parameter.isOptional) {
          throw InvalidGenerationSourceError(
            '`@Tw()` child parameter must be required.',
            element: method,
          );
        }
        if (!_isFlutterWidgetType(parameter.type)) {
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
