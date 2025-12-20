import 'package:test/test.dart';
import 'package:twind_generator/src/candidate.dart';

void main() {
  group('Candidate.tryParse', () {
    test('empty', () {
      expect(Candidate.tryParse(''), isNull);
    });

    test('root only', () {
      expect(
        Candidate.tryParse('underline'),
        equals(
          const Candidate(
            variants: [],
            root: 'underline',
            values: [],
            modifier: null,
          ),
        ),
      );
    });

    test('root with leading minus', () {
      expect(
        Candidate.tryParse('-bg'),
        equals(
          const Candidate(
            variants: [],
            root: 'bg',
            values: [],
            leadingMinus: true,
            modifier: null,
          ),
        ),
      );
    });

    test('root with value', () {
      expect(
        Candidate.tryParse('bg-red'),
        equals(
          const Candidate(
            variants: [],
            root: 'bg',
            values: ['red'],
            modifier: null,
          ),
        ),
      );
    });

    test('root with leading minus and value', () {
      expect(
        Candidate.tryParse('-bg-red'),
        equals(
          const Candidate(
            variants: [],
            root: 'bg',
            values: ['red'],
            leadingMinus: true,
            modifier: null,
          ),
        ),
      );
    });

    test('root with multiple values', () {
      expect(
        Candidate.tryParse('bg-red-500'),
        equals(
          const Candidate(
            variants: [],
            root: 'bg',
            values: ['red', '500'],
            modifier: null,
          ),
        ),
      );
    });

    test('root with leading minus and multiple values', () {
      expect(
        Candidate.tryParse('-bg-red-500'),
        equals(
          const Candidate(
            variants: [],
            root: 'bg',
            values: ['red', '500'],
            leadingMinus: true,
            modifier: null,
          ),
        ),
      );
    });

    test('root with modifier', () {
      expect(
        Candidate.tryParse('bg-red-500/20'),
        equals(
          const Candidate(
            variants: [],
            root: 'bg',
            values: ['red', '500'],
            modifier: '20',
          ),
        ),
      );
    });

    test('root with leading minus and modifier', () {
      expect(
        Candidate.tryParse('-bg-red-500/20'),
        equals(
          const Candidate(
            variants: [],
            root: 'bg',
            values: ['red', '500'],
            leadingMinus: true,
            modifier: '20',
          ),
        ),
      );
    });

    test('root with modifier and value', () {
      expect(
        Candidate.tryParse('bg-red-500/20'),
        equals(
          const Candidate(
            variants: [],
            root: 'bg',
            values: ['red', '500'],
            modifier: '20',
          ),
        ),
      );
    });

    test('root with leading minus and modifier and value', () {
      expect(
        Candidate.tryParse('-bg-red-500/20'),
        equals(
          const Candidate(
            variants: [],
            root: 'bg',
            values: ['red', '500'],
            leadingMinus: true,
            modifier: '20',
          ),
        ),
      );
    });

    test('root with variant', () {
      expect(
        Candidate.tryParse('md:bg-red-500'),
        equals(
          const Candidate(
            variants: ['md'],
            root: 'bg',
            values: ['red', '500'],
            modifier: null,
          ),
        ),
      );
    });

    test('root with leading minus and variant', () {
      expect(
        Candidate.tryParse('md:-bg-red-500'),
        equals(
          const Candidate(
            variants: ['md'],
            root: 'bg',
            values: ['red', '500'],
            leadingMinus: true,
            modifier: null,
          ),
        ),
      );
    });

    test('root with multiple variants', () {
      expect(
        Candidate.tryParse('md:active:bg-red-500'),
        equals(
          const Candidate(
            variants: ['md', 'active'],
            root: 'bg',
            values: ['red', '500'],
            modifier: null,
          ),
        ),
      );
    });

    test('root with leading minus and multiple variants', () {
      expect(
        Candidate.tryParse('md:active:-bg-red-500'),
        equals(
          const Candidate(
            variants: ['md', 'active'],
            root: 'bg',
            values: ['red', '500'],
            leadingMinus: true,
            modifier: null,
          ),
        ),
      );
    });

    test('root with variant and modifier', () {
      expect(
        Candidate.tryParse('md:bg-red-500/20'),
        equals(
          const Candidate(
            variants: ['md'],
            root: 'bg',
            values: ['red', '500'],
            modifier: '20',
          ),
        ),
      );
    });

    test('root with leading minus and variant and modifier', () {
      expect(
        Candidate.tryParse('md:-bg-red-500/20'),
        equals(
          const Candidate(
            variants: ['md'],
            root: 'bg',
            values: ['red', '500'],
            leadingMinus: true,
            modifier: '20',
          ),
        ),
      );
    });

    test('complex', () {
      expect(
        Candidate.tryParse('md:active:bg-red-500/20'),
        equals(
          const Candidate(
            variants: ['md', 'active'],
            root: 'bg',
            values: ['red', '500'],
            modifier: '20',
          ),
        ),
      );
    });

    test('complex with leading minus', () {
      expect(
        Candidate.tryParse('md:active:-bg-red-500/20'),
        equals(
          const Candidate(
            variants: ['md', 'active'],
            root: 'bg',
            values: ['red', '500'],
            leadingMinus: true,
            modifier: '20',
          ),
        ),
      );
    });
  });

  group('parseCandidates', () {
    test('empty', () {
      expect(parseCandidates(''), isEmpty);
    });

    test('single', () {
      expect(parseCandidates('bg-red-500'), [
        const Candidate(
          variants: [],
          root: 'bg',
          values: ['red', '500'],
          modifier: null,
        ),
      ]);
    });

    test('multiple', () {
      final input = 'px-4 py-2 bg-red-500/20 md:bg-red-500';
      expect(parseCandidates(input), [
        const Candidate(
          variants: [],
          root: 'px',
          values: ['4'],
          modifier: null,
        ),
        const Candidate(
          variants: [],
          root: 'py',
          values: ['2'],
          modifier: null,
        ),
        const Candidate(
          variants: [],
          root: 'bg',
          values: ['red', '500'],
          modifier: '20',
        ),
        const Candidate(
          variants: ['md'],
          root: 'bg',
          values: ['red', '500'],
          modifier: null,
        ),
      ]);
    });
  });
}
