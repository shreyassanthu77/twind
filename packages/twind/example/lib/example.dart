import 'package:flutter/material.dart';
import 'package:twind/twind.dart';

part 'example.g.dart';

class RedBox extends StatelessWidget with _$RedBox {
  const RedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return _red(const SizedBox());
  }

  @override
  @Tw('bg-red-500 px-4 py-2')
  Widget _red(Widget child);
}
