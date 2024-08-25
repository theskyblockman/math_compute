import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';

/// A mathematical function, taking one or more parameters (a function taking 0 arguments is a constant).
abstract class MathFunction {
  /// The name of the function, for the lexical analysis.
  String get name;

  /// The display name of the function (for display).
  String get displayName => name;

  /// The number of parameters the function takes.
  int get requiredParameterCount;

  /// Computes the function.
  Result compute(ComputeContext ctx, List<Result> input);

  /// Creates the function.
  const MathFunction();
}
