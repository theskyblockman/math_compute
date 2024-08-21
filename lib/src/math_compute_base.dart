import 'package:math_compute/src/computable.dart';
import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/operators.dart';
import 'package:rational/rational.dart';

abstract class ImaginaryValue {
  const ImaginaryValue();

  Rational approximate([int? digits]);

  String get representation;

  bool get approximable => true;

  @override
  bool operator ==(Object other) {
    return other is ImaginaryValue && other.representation == representation;
  }

  @override
  int get hashCode => Object.hash(representation, approximable);

  @override
  String toString() => representation;
}

enum Precedence {
  additive(2), // + and -
  multiplicative(3), // * and /
  calls(4), // Calls (sqrt, pow/^, log, etc.)
  highest(5); // For e (like in 2e6)

  final int priority;

  const Precedence(this.priority);
}

class Expression implements Computable {
  final Computable leftHand;
  final Computable rightHand;
  final Operator operator;

  @override
  Result compute(ComputeContext ctx) =>
      operator.compute(ctx, leftHand.compute(ctx), rightHand.compute(ctx));

  Expression(
      {required this.operator,
      required this.leftHand,
      required this.rightHand});

  @override
  String toString() {
    return "($leftHand${operator.rawSign}$rightHand)";
  }
}
