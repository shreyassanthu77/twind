import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Mimicking your syntax exactly
class BlueBox extends StatelessWidget with _$BlueBox {
  const BlueBox({super.key});

  // Declared without a body
  @override
  Widget inner({Widget? child});

  @override
  Widget build(BuildContext context) {
    return inner(child: const Text('Hello World'));
  }
}

mixin _$BlueBox {
  Widget inner({Widget? child}) {
    return ColoredBox(color: Colors.blue, child: child);
  }
}

void main() {
  testWidgets('BlueBox syntax test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BlueBox()));

    expect(find.byType(ColoredBox), findsWidgets);
    expect(find.text('Hello World'), findsOneWidget);

    final coloredBoxes = tester.widgetList<ColoredBox>(find.byType(ColoredBox));
    final blueBox = coloredBoxes.where((b) => b.color == Colors.blue).single;
    expect(blueBox.color, Colors.blue);
  });
}
