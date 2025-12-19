import 'package:flutter_test/flutter_test.dart';
import 'package:twind/twind.dart';

void main() {
  test('Tw annotation exists', () {
    const annotation = Tw('');
    expect(annotation, isA<Tw>());
  });
}
