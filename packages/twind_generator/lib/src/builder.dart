import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'tw_generator.dart';

/// Builds generators for the `@Tw()` annotation.
Builder twBuilder(BuilderOptions options) {
  return SharedPartBuilder([TwGenerator()], 'tw');
}
