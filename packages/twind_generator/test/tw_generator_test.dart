import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:test/test.dart';
import 'package:twind_generator/twind_generator.dart';

import 'example.dart';

void main() {
  //   test('generates a mixin for @Tw() methods', () async {
  //     const input = """
  // import 'package:twind/twind.dart';
  //
  // part 'example.g.dart';
  //
  // class Widget {}
  //
  // abstract class RedBox {
  //   @Tw('bg-red-500 px-4 py-2')
  //   Widget _red({Widget? child});
  // }
  // """;
  //
  //     final builder = twBuilder(BuilderOptions.empty);
  //     final reader = await PackageAssetReader.currentIsolate();
  //
  //     await testBuilder(
  //       builder,
  //       {'twind_generator|lib/example.dart': input},
  //       rootPackage: 'twind_generator',
  //       reader: reader,
  //       outputs: {
  //         'twind_generator|lib/example.twind.g.part': decodedMatches(
  //           allOf([contains('mixin _\$RedBox'), contains('Widget _red')]),
  //         ),
  //       },
  //     );
  //   });
}
