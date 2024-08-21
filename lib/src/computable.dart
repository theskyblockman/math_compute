import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';

abstract class Computable {
  Result compute(ComputeContext ctx);
}
