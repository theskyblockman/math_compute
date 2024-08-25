import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';

/// An abstract class making sure an object can be computed in a [Result].
abstract class Computable {
  /// Computes the value(s) stored in this object into a [Result].
  Result compute(ComputeContext ctx);
}
