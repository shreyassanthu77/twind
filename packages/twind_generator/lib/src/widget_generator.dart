import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:twind_generator/src/candidate.dart';

typedef Padding = (double, double, double, double);

String generateWidget(List<Candidate> candidates, Element element) {
  Padding padding = (0, 0, 0, 0);
  int color = 0;
  for (final candidate in candidates) {
    switch (candidate.root) {
      case "p":
      case "px":
      case "py":
      case "pl":
      case "pt":
      case "pr":
      case "pb":
        padding = _applyPadding(candidate, padding, element);
        break;
      case "bg":
        color = _applyColor(candidate, color, element);
    }
  }

  final withColor = _generateColor(color, "child");
  final withPadding = _generatePadding(padding, withColor);
  return withPadding;
}

String _generatePadding(Padding padding, String child) {
  if (padding.$1 == 0 &&
      padding.$2 == 0 &&
      padding.$3 == 0 &&
      padding.$4 == 0) {
    return child;
  }

  return """Padding(
			padding: EdgeInsets.fromLTRB(${padding.$1}, ${padding.$2}, ${padding.$3}, ${padding.$4}),
			child: $child,
		)""";
}

Padding _applyPadding(Candidate candidate, Padding padding, Element element) {
  final value = switch (candidate.value) {
    StringValue(:final inner) => inner,
    ArbitraryValue(:final inner) => inner,
    NoValue() => "0",
  };
  final paddingValue = double.tryParse(value);
  if (paddingValue == null) {
    throw InvalidGenerationSourceError(
      'Invalid padding value: `$value`.',
      element: element,
    );
  }
  switch (candidate.root) {
    case "p":
      return (paddingValue, paddingValue, paddingValue, paddingValue);
    case "px":
      return (padding.$1, paddingValue, padding.$3, paddingValue);
    case "py":
      return (paddingValue, padding.$2, paddingValue, padding.$4);
    case "pl":
      return (padding.$1, padding.$2, padding.$3, paddingValue);
    case "pt":
      return (paddingValue, padding.$2, padding.$3, padding.$4);
    case "pr":
      return (padding.$1, paddingValue, padding.$3, padding.$4);
    case "pb":
      return (padding.$1, paddingValue, padding.$3, padding.$4);
    default:
      throw AssertionError("Unreachable");
  }
}

String _generateColor(int color, String child) {
  return """ColoredBox(
			color: Color(0x${color.toRadixString(16).padLeft(8, '0')}),
			child: $child,
		)""";
}

int _applyColor(Candidate candidate, int color, Element element) {
  final value = switch (candidate.value) {
    StringValue(:final inner) => throw InvalidGenerationSourceError(
      'Named colors are not supported yet: `$inner`.',
      element: element,
    ),
    ArbitraryValue(:final inner) => inner,
    NoValue() => throw InvalidGenerationSourceError(
      'Invalid color value: `${candidate.value}`.',
      element: element,
    ),
  };
  final colorValue = switch (value) {
    _ when value.startsWith('#') => _applyHexColor(value.substring(1)),
    _ when value.startsWith("0x") || value.startsWith("0X") => _applyHexColor(
      value.substring(2),
    ),
    _ => null,
  };
  if (colorValue == null) {
    throw InvalidGenerationSourceError(
      'Invalid color value: `$value`.',
      element: element,
    );
  }
  switch (candidate.root) {
    case "bg":
      return colorValue;
    default:
      throw AssertionError("Unreachable");
  }
}

/// #rgb
/// #rgba
/// #rrggbb
/// #rrggbbaa
int? _applyHexColor(String hex) {
  switch (hex.length) {
    case < 3:
      return null;
    case 3:
      return int.parse(
        "ff${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}",
        radix: 16,
      );
    case 4:
      return int.parse(
        "${hex[3]}${hex[3]}${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}",
        radix: 16,
      );
    case 6:
      return int.parse("ff$hex", radix: 16);
    case 8:
      return int.parse(hex, radix: 16);
    default:
      return null;
  }
}
