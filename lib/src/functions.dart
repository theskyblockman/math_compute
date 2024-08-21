import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';

abstract class MathFunction {
  String get name;

  String get displayName => name;

  int get requiredParameterCount;

  Result compute(ComputeContext ctx, List<Result> input);

  const MathFunction();
}
