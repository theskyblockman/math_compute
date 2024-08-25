import 'dart:math' as math;

import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/functions.dart';
import 'package:math_compute/src/utils/math.dart' as internal_math;
import 'package:rational/rational.dart';

double _convertDegreesToRadians(ComputeContext ctx, Result input) {
  if (!ctx.convertDegreesToRadians) return input.approximate().toDouble();

  return degreesToRadians(input);
}

/// Converts the [input] into radians.
double degreesToRadians(Result input) {
  return (input.approximate() *
          (Rational.parse(math.pi.toString()) / Rational(BigInt.from(180))))
      .toDouble();
}

class _Sinus extends MathFunction {
  const _Sinus(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(internal_math
          .sin(_convertDegreesToRadians(ctx, input.single))
          .toString()));

  @override
  int get requiredParameterCount => 1;
}

/// Takes the sine of a number.
const sin = _Sinus('sin');

class _ArcSinus extends MathFunction {
  const _ArcSinus(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(
          math.asin(_convertDegreesToRadians(ctx, input.single)).toString()));

  @override
  int get requiredParameterCount => 1;
}

/// Takes the arc sine of a number when written as "arcsin".
const arcsin = _ArcSinus('arcsin');

/// Takes the arc sine of a number when written as "asin".
const asin = _ArcSinus('asin');

/// Takes the arc sine of a number when written as "asn".
const asn = _ArcSinus('asn');

class _Cosinus extends MathFunction {
  const _Cosinus(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(internal_math
          .cos(_convertDegreesToRadians(ctx, input.single))
          .toString()));

  @override
  int get requiredParameterCount => 1;
}

/// Takes the cosine of a number.
const cos = _Cosinus('cos');

class _ArcCosinus extends MathFunction {
  const _ArcCosinus(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(
          math.acos(_convertDegreesToRadians(ctx, input.single)).toString()));

  @override
  int get requiredParameterCount => 1;
}

/// Takes the arc cosine of a number when written as "arccos".
const arccos = _ArcCosinus('arccos');

/// Takes the arc cosine of a number when written as "acos".
const acos = _ArcCosinus('acos');

/// Takes the arc cosine of a number when written as "acs".
const acs = _ArcCosinus('acs');

class _Tangent extends MathFunction {
  const _Tangent(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(internal_math
          .tan(_convertDegreesToRadians(ctx, input.single))
          .toString()));

  @override
  int get requiredParameterCount => 1;
}

/// Takes the tangent of a number.
const tan = _Tangent('tan');

class _ArcTangent extends MathFunction {
  const _ArcTangent(this.name);

  @override
  final String name;

  @override
  Result compute(ComputeContext ctx, List<Result> input) => Result(
      clean: Rational.parse(
          math.atan(_convertDegreesToRadians(ctx, input.single)).toString()));

  @override
  int get requiredParameterCount => 1;
}

/// Takes the arc tangent of a number when written as "arctan".
const arctan = _ArcTangent('arctan');

/// Takes the arc tangent of a number when written as "atan".
const atan = _ArcTangent('atan');
