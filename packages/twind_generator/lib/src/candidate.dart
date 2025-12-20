/// A candidate represents a single tailwind class.
/// For example,
/// `md:active:bg-red-500/20`
/// is a candidate with the following properties:
/// - root: `"bg"`
/// - variants: `["md", "active"]`
/// - values: `["red", "500"]`
/// - modifier: `20`
///
/// root can optionally be prefixed with a minus sign (`-`).
/// This is usually used to flip the sign of the value associated with the root.
/// For example, `-top-4` will have a tap value of `-4`.
final class Candidate {
  final List<String> variants;
  final String root;
  final bool leadingMinus;
  final List<String> values;
  final String? modifier;

  const Candidate({
    required this.variants,
    required this.root,
    required this.values,
    this.leadingMinus = false,
    this.modifier,
  });

  static Candidate? tryParse(final String candidate) {
    if (candidate.isEmpty) return null;

    final (variants, rest) = switch (candidate.trim().split(':')) {
      [final single] => (<String>[], single),
      [...final variants, final last] => (variants, last),
      _ => throw ArgumentError('Invalid candidate: `$candidate`.'),
    };
    final modifierIdx = rest.lastIndexOf('/');
    final (rootValues, modifier) = switch (modifierIdx) {
      -1 => (rest, null as String?),
      final idx => (rest.substring(0, idx), rest.substring(idx + 1)),
    };
    final (leadingMinux, root, values) = switch (rootValues.split("-")) {
      ["", final root, ...final values] => (true, root, values),
      [final root, ...final values] => (false, root, values),
      _ => throw ArgumentError('Invalid candidate: `$candidate`.'),
    };
    return Candidate(
      variants: variants,
      root: root,
      values: values,
      modifier: modifier,
      leadingMinus: leadingMinux,
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
        _listEquals(values, other.values) &&
        modifier == other.modifier &&
        leadingMinus == other.leadingMinus;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(variants),
      root,
      Object.hashAll(values),
      modifier,
      leadingMinus,
    );
  }

  @override
  String toString() {
    return 'Candidate{variants: $variants, leadingMinus: $leadingMinus, root: "$root", values: $values, modifier: $modifier}';
  }
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
