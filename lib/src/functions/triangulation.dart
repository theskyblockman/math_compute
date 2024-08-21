import 'dart:math' as math;

import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/utils/math.dart' as internal_math;
import 'package:rational/rational.dart';

import '../functions.dart';

class _Sinus extends MathFunction {
  const _Sinus(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(
          internal_math.sin(input.single.approximate().toDouble()).toString()));

  @override
  int get requiredParameterCount => 1;
}

const sin = _Sinus('sin');

class _ArcSinus extends MathFunction {
  const _ArcSinus(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(
          math.asin(input.single.approximate().toDouble()).toString()));

  @override
  int get requiredParameterCount => 1;
}

const arcsin = _ArcSinus('arcsin');
const asin = _ArcSinus('asin');
const asn = _ArcSinus('asn');

class _Cosinus extends MathFunction {
  const _Cosinus(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(
          internal_math.cos(input.single.approximate().toDouble()).toString()));

  @override
  int get requiredParameterCount => 1;
}

const cos = _Cosinus('cos');

class _ArcCosinus extends MathFunction {
  const _ArcCosinus(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(
          math.acos(input.single.approximate().toDouble()).toString()));

  @override
  int get requiredParameterCount => 1;
}

const arccos = _ArcCosinus('arccos');
const acos = _ArcCosinus('acos');
const acs = _ArcCosinus('acs');

class _Tangent extends MathFunction {
  const _Tangent(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(
          internal_math.tan(input.single.approximate().toDouble()).toString()));

  @override
  int get requiredParameterCount => 1;
}

const tan = _Tangent('tan');

class _ArcTangent extends MathFunction {
  const _ArcTangent(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(
          math.atan(input.single.approximate().toDouble()).toString()));

  @override
  int get requiredParameterCount => 1;
}

const arctan = _ArcTangent('arctan');
const atan = _ArcTangent('atan');
