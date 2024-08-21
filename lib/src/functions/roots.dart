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

const sqrt = _Sqrt('sqrt');
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

const cubeRoot = _CubeRoot('cbrt');
const cubeRootAlt = _CubeRoot('∛');
