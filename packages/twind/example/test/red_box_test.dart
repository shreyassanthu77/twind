import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:twind_example/example.dart';

void main() {
  testWidgets('RedBox uses generated widget wrappers', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RedBox()));

    expect(find.byType(SizedBox), findsOneWidget);
  });
}
