// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twind/twind.dart';

class RedBox extends StatelessWidget with _$RedBox {
  const RedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return _red(child: const SizedBox());
  }

  @override
  @Tw('bg-red-500 px-4 py-2')
  Widget _red({final Widget? child});
}

mixin _$RedBox {
  Widget _red({final Widget? child}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: child,
      ),
    );
  }
}

void main() {
  testWidgets('RedBox can be built', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RedBox()));

    expect(find.byType(RedBox), findsOneWidget);
    expect(find.byType(DecoratedBox), findsOneWidget);
  });
}
