import 'package:math_compute/src/lexing.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'shared.dart';

void main() {
  group("Lexing tests", () {
    setUp(initializeLogging);
    Map<String, List<String>> toTest = {
      "2+2": ["2", "+", "2"],
      "22*3+234": ['22', '*', '3', '+', '234'],
      "2*(2+3)": ['2', '*', '(', '2', '+', '3', ')'],
      "2.334": ['2.334'],
      "5!": ['5', '!'],
      "-5+1": ['-', '5', '+', '1'],
      "3+4*2/(1-5)^2^3": [
        '3',
        '+',
        '4',
        '*',
        '2',
        '/',
        '(',
        '1',
        '-',
        '5',
        ')',
        '^',
        '2',
        '^',
        '3'
      ],
      '3 + 4 × 2 ÷ ( 1 − 5 ) ^ 2 ^ 3': [
        '3',
        '+',
        '4',
        '×',
        '2',
        '÷',
        '(',
        '1',
        '−',
        '5',
        ')',
        '^',
        '2',
        '^',
        '3'
      ],
      'sin ( max ( 2, 3 ) ÷ 3 × π )': [
        'sin',
        '(',
        'max',
        '(',
        '2',
        ',',
        '3',
        ')',
        '÷',
        '3',
        '×',
        'π',
        ')'
      ]
    };

    for (final MapEntry(key: raw, value: tokens) in toTest.entries) {
      test(raw, () {
        final separatedTokens = separateTokens(raw);
        print(
            "Token types: ${separatedTokens.map((e) => e.type.runtimeType.toString()).join('; ')}");
        expect(separatedTokens.map((e) => e.rawValue), tokens);
      });
    }
  });
}
