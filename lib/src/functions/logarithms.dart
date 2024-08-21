import 'dart:math' as math;

import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/functions.dart';
import 'package:math_compute/src/utils/math.dart' as internal_math;
import 'package:rational/rational.dart';

class _NaturalLogarithm extends MathFunction {
  const _NaturalLogarithm(this.name);

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(
          math.log(input.single.approximate().toDouble()).toString()));

  @override
  final String name;

  @override
  int get requiredParameterCount => 1;
}

const ln = _NaturalLogarithm('ln');

class _DecimalLogarithm extends MathFunction {
  const _DecimalLogarithm(this.name);

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(internal_math
          .log10(input.single.approximate().toDouble())
          .toString()));

  @override
  final String name;

  @override
  int get requiredParameterCount => 1;
}

const log = _DecimalLogarithm('log');

class _BinaryLogarithm extends MathFunction {
  const _BinaryLogarithm(this.name);

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(internal_math
          .log2(input.single.approximate().toDouble())
          .toString()));

  @override
  final String name;

  @override
  int get requiredParameterCount => 1;
}

const log2 = _BinaryLogarithm('log2');
const lb = _BinaryLogarithm('lb');
