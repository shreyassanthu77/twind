/// Candidate :: Variant* '-'? Root ('-' Value)? ('/' Modifier)?
///
/// Variant :: any ':'
///
/// Root :: [a-zA-Z_][a-zA-Z_]*
/// Value :: ArbitraryValue | StringListValue
/// ArbitraryValue :: '[' any+ ']'
/// StringListValue :: any+
/// Modifier :: any+
final class Candidate {
  final List<String> variants;
  final String root;
  final Value value;
  final String? modifier;

  const Candidate({
    required this.variants,
    required this.root,
    required this.value,
    this.modifier,
  });

  static Candidate? tryParse(final String candidate) {
    if (candidate.isEmpty) return null;
    final [...variants, rest] = candidate.split(':');
    final (rootWithValue0, modifier) = switch (rest.lastIndexOf('/')) {
      -1 => (rest, null as String?),
      final idx => (rest.substring(0, idx), rest.substring(idx + 1)),
    };
    final (leadingMinux, rootWithValue) = switch (rootWithValue0[0]) {
      '-' => (true, rootWithValue0.substring(1)),
      _ => (false, rootWithValue0),
    };
    final (root, maybeValue) = switch (rootWithValue.indexOf('-')) {
      -1 => (rootWithValue, null as String?),
      final idx => (
        rootWithValue.substring(0, idx),
        rootWithValue.substring(idx + 1),
      ),
    };
    final value = switch (maybeValue) {
      null => const NoValue(),
      final s when s.startsWith('[') && s.endsWith(']') => ArbitraryValue(
        s.substring(1, s.length - 1),
      ),
      final s => StringValue(s, leadingMinux),
    };
    return Candidate(
      variants: variants,
      root: root,
      value: value,
      modifier: modifier,
    );
  }

  static bool _listEquals(final List<String> a, final List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;
    return other is Candidate &&
        _listEquals(variants, other.variants) &&
        root == other.root &&
        value == other.value &&
        modifier == other.modifier;
  }

  @override
  int get hashCode {
    return Object.hash(Object.hashAll(variants), root, value, modifier);
  }

  @override
  String toString() {
    return 'Candidate{variants: $variants, root: "$root", value: $value, modifier: $modifier}';
  }
}

sealed class Value {
  const Value();
}

final class NoValue extends Value {
  const NoValue();

  @override
  bool operator ==(Object other) => other is NoValue;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'NoValue';
}

final class ArbitraryValue extends Value {
  final String inner;

  const ArbitraryValue(this.inner);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ArbitraryValue && inner == other.inner;

  @override
  int get hashCode => inner.hashCode;

  @override
  String toString() => 'ArbitraryValue{inner: "$inner"}';
}

final class StringValue extends Value {
  final bool leadingMinus;
  final String inner;

  const StringValue(this.inner, [this.leadingMinus = false]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StringValue &&
          inner == other.inner &&
          leadingMinus == other.leadingMinus;

  @override
  int get hashCode => Object.hash(inner, leadingMinus);

  @override
  String toString() =>
      'StringValue{inner: "$inner", leadingMinus: $leadingMinus}';
}

final _whitespace = RegExp(r'\s+');
List<Candidate> parseCandidates(String className) {
  final candidates = <Candidate>[];
  for (final candidate in className.split(_whitespace)) {
    final parsed = Candidate.tryParse(candidate);
    if (parsed != null) candidates.add(parsed);
  }
  return candidates;
}
