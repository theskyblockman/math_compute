import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/functions.dart';

class _Min extends MathFunction {
  const _Min();

  @override
  final String name = 'min';

  @override
  Result compute(ComputeContext ctx, List<Result> input) {
    if (input.first.approximate() < input.last.approximate()) {
      return input.first;
    } else {
      return input.last;
    }
  }

  @override
  int get requiredParameterCount => 2;
}

const min = _Min();

class _Max extends MathFunction {
  const _Max();

  @override
  final String name = 'max';

  @override
  Result compute(ComputeContext ctx, List<Result> input) {
    if (input.first.approximate() > input.last.approximate()) {
      return input.first;
    } else {
      return input.last;
    }
  }

  @override
  int get requiredParameterCount => 2;
}

const max = _Max();
