import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/errors.dart';
import 'package:math_compute/src/math_compute_base.dart';
import 'package:rational/rational.dart';

/// An operator, a character put between two values to define an operation.
abstract class Operator {
  /// Creates the operator.
  const Operator();

  /// Computes the result of the operator.
  Result compute(ComputeContext context, Result leftHand, Result rightHand);

  /// The precedence of the operator.
  Precedence get precedence;

  /// Is the operator be left associative.
  bool get isLeftAssociative => true;

  /// The raw sign of the operator for lexical analysis.
  String get rawSign;

  /// The sign of the operator for display.
  String get displaySign => rawSign;

  @override
  String toString() => displaySign;
}

/// An operator for addition.
const plus = _PlusOperator();

class _PlusOperator extends Operator {
  const _PlusOperator();

  @override
  Result compute(ComputeContext context, Result leftHand, Result rightHand) =>
      leftHand + rightHand;

  @override
  Precedence get precedence => Precedence.additive;

  @override
  String get rawSign => '+';
}

/// An operator for subtraction when written as "-".
const minus = _MinusOperator('-');

/// An operator for subtraction when written as "−".
const minusAlt = _MinusOperator('−');

/// An operator for subtraction.
class _MinusOperator extends Operator {
  const _MinusOperator(this.rawSign);

  @override
  Result compute(ComputeContext context, Result leftHand, Result rightHand) =>
      leftHand - rightHand;

  @override
  Precedence get precedence => Precedence.additive;

  @override
  final String rawSign;

  @override
  String get displaySign => '−';
}

/// An operator for multiplication when written as "*".
const multiplication = _MultiplicationOperator('*');

/// An operator for multiplication when written as "×".
const multiplicationAlt = _MultiplicationOperator('×');

class _MultiplicationOperator extends Operator {
  const _MultiplicationOperator(this.rawSign);

  @override
  Result compute(ComputeContext context, Result leftHand, Result rightHand) =>
      leftHand * rightHand;

  @override
  Precedence get precedence => Precedence.multiplicative;

  @override
  final String rawSign;

  @override
  String get displaySign => '×';
}

/// An operator for division when written as "/".
const division = _DivisionOperator('/');

/// An operator for division when written as "÷".
const divisionAlt = _DivisionOperator('÷');

class _DivisionOperator extends Operator {
  const _DivisionOperator(this.rawSign);

  @override
  Result compute(ComputeContext context, Result leftHand, Result rightHand) {
    if (rightHand.approximate() == Rational.zero) {
      throw ComputationError(ComputationStep.eval,
          message: 'Cannot divide by zero');
    }

    return leftHand / rightHand;
  }

  @override
  Precedence get precedence => Precedence.multiplicative;

  @override
  final String rawSign;

  @override
  String get displaySign => '÷';
}

/// An operator for power.
final power = _PowerOperator();

class _PowerOperator extends Operator {
  const _PowerOperator();

  @override
  Result compute(ComputeContext context, Result leftHand, Result rightHand) =>
      leftHand ^ rightHand;

  @override
  Precedence get precedence => Precedence.calls;

  @override
  bool get isLeftAssociative => false;

  @override
  String get rawSign => '^';
}
