import 'dart:math' as math;

import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/functions.dart';
import 'package:rational/rational.dart';

class _Exponential extends MathFunction {
  const _Exponential();

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(
          math.exp(input.single.approximate().toDouble()).toString()));

  @override
  String get name => 'exp';

  @override
  int get requiredParameterCount => 1;
}

/// Takes the exponential of a number.
const exp = _Exponential();
