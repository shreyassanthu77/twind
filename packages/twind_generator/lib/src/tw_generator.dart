import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:twind/twind.dart';

/// Generator for the `@Tw()` annotation.
class TwGenerator extends GeneratorForAnnotation<Tw> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@Tw can only be applied to classes.',
        element: element,
      );
    }

    final className = element.name;
    final generatedClassName = '_\$$className';

    return '''
// ignore_for_file: prefer_const_constructors_in_immutables

class $generatedClassName extends StatelessWidget {
  const $generatedClassName({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
''';
  }
}
