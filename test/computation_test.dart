import 'dart:math' as math;

import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/utils/math.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'shared.dart';

void main() {
  group("Computation tests", () {
    setUp(initializeLogging);
    Map<String, double> toTest = {
      "2+2": 4,
      "3+4*2/(1-5)^2^3": 3.0001220703125,
      '5!': 120,
      "1e5": 100000,
      'sin ( max ( 2, 3 ) ÷ 3 × π )': sin(math.pi),
      'pi': math.pi,
      '2pi': math.pi * 2,
      '-5+5': 0
    };
    for (final MapEntry(key: raw, value: result) in toTest.entries) {
      test('$raw=$result', () {
        final computed = compute(raw);
        final approximation = computed.approximate();
        print('$approximation≈${approximation.toDouble()}');
        expect(approximation.toDouble(), result);
      });
    }
  });
}
