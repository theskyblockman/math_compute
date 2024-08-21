import 'package:math_compute/src/lexing.dart';
import 'package:math_compute/src/parsing.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'shared.dart';

void main() {
  group("Parsing tests", () {
    setUp(() => initializeLogging(['Parser']));
    Map<List<Token>, List<String>> toTest = {
      separateTokens("2+2"): ['2', '2', '+'],
      separateTokens("3+4*2/(1-5)^2^3"): [
        ...'3 4 2 * 1 5 - 2 3 ^ ^ / +'.split(' ')
      ],
      separateTokens('5!'): ['5', '!'],
      separateTokens("1e5"): ['1e5'],
      separateTokens('sin ( max ( 2, 3 ) ÷ 3 × π )'): [
        ...'2 3 max 3 ÷ π × sin'.split(' '),
      ],
      separateTokens('2pi'): ['2', 'pi', '*'],
    };

    for (final MapEntry(key: tokens, value: result) in toTest.entries) {
      test(
          tokens
              .map(
                (e) => e.rawValue,
              )
              .join(), () {
        print(tokens);
        final exp = toRPN(tokens);
        expect(
            exp
                .map(
                  (e) => e.rawValue,
                )
                .toList(),
            result);
      });
    }
  });
}
