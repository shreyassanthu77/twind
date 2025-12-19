# twind

Tailwind-style utility classes for Flutter widgets with compile-time code generation.

## Installation

```yaml
dependencies:
  twind: ^0.0.1

dev_dependencies:
  twind_generator: ^0.0.1
  build_runner: ^2.4.0
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:twind/twind.dart';

part 'my_widget.g.dart';

@Tw()
class MyButton extends _$MyButton {
  const MyButton({super.key, required super.child});
}
```

Run code generation:

```bash
dart run build_runner build
```

## Status

⚠️ **Early Development** - This package is in active development. The API will change.

## License

MIT
