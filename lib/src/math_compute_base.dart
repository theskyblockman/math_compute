import 'package:math_compute/src/computable.dart';
import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/operators.dart';
import 'package:rational/rational.dart';

/// A value that cannot exactly be converted to a double (like 1/3.)
abstract class ImaginaryValue {
  /// Creates the imaginary value.
  const ImaginaryValue();

  /// Gives an approximation of the value.
  Rational approximate([int? digits]);

  /// The representation of the value for display.
  String get representation;

  /// Can the value be approximated at all.
  bool get approximable => true;

  @override
  bool operator ==(Object other) {
    return other is ImaginaryValue && other.hashCode == hashCode;
  }

  @override
  int get hashCode => Object.hash(representation, approximable);

  @override
  String toString() => representation;
}

/// An enumeration of the precedence given to operators.
enum Precedence {
  /// Additive operators are + and -.
  additive(2),

  /// Multiplicative operators are * and /.
  multiplicative(3),

  /// Calls like sqrt and ^.
  calls(4), // Calls (sqrt, pow/^, log, etc.)
  /// The highest precedence.
  highest(5); // For e (like in 2e6)

  /// The priority of the operator.
  final int priority;

  /// Creates the precedence.
  const Precedence(this.priority);
}

/// An computable expression made out of a left hand, an operator and a right
/// hand.
class Expression implements Computable {
  /// The left hand of the expression.
  final Computable leftHand;

  /// The right hand of the expression.
  final Computable rightHand;

  /// The operator of the expression.
  final Operator operator;

  @override
  Result compute(ComputeContext ctx) =>
      operator.compute(ctx, leftHand.compute(ctx), rightHand.compute(ctx));

  /// Creates the expression.
  Expression(
      {required this.operator,
      required this.leftHand,
      required this.rightHand});

  @override
  String toString() {
    return "($leftHand${operator.rawSign}$rightHand)";
  }
}
