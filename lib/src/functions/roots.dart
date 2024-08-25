import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/functions.dart';
import 'package:math_compute/src/utils/math.dart' as internal_math;

class _Sqrt extends MathFunction {
  const _Sqrt(this.name);

  @override
  Result compute(ComputeContext ctx, List<Result> input) {
    return internal_math.sqrt(input.single.approximate().toDouble());
  }

  @override
  final String name;

  @override
  String get displayName => '√';

  @override
  int get requiredParameterCount => 1;
}

/// Takes the square root of a number when written as "sqrt.
const sqrt = _Sqrt('sqrt');

/// Takes the square root of a number when written as "√".
const sqrtAlt = _Sqrt('√');

class _CubeRoot extends MathFunction {
  const _CubeRoot(this.name);

  @override
  Result compute(ComputeContext ctx, List<Result> input) {
    return internal_math.cubeRoot(input.single.approximate().toDouble());
  }

  @override
  final String name;

  @override
  String get displayName => '∛';

  @override
  int get requiredParameterCount => 1;
}

/// Takes the cube root of a number when written as "cbrt".
const cubeRoot = _CubeRoot('cbrt');

/// Takes the cube root of a number when written as "∛".
const cubeRootAlt = _CubeRoot('∛');
