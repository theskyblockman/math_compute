import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/errors.dart';
import 'package:rational/rational.dart';

import 'math_compute_base.dart';

abstract class Operator {
  Result compute(ComputeContext context, Result leftHand, Result rightHand);

  Precedence get precedence;

  bool get isLeftAssociative => true;

  String get rawSign;

  String get displaySign => rawSign;

  @override
  String toString() {
    return rawSign;
  }
}

class PlusOperator extends Operator {
  @override
  Result compute(ComputeContext context, Result leftHand, Result rightHand) =>
      leftHand + rightHand;

  @override
  Precedence get precedence => Precedence.additive;

  @override
  String get rawSign => '+';
}

class MinusOperator extends Operator {
  @override
  Result compute(ComputeContext context, Result leftHand, Result rightHand) =>
      leftHand - rightHand;

  @override
  Precedence get precedence => Precedence.additive;

  @override
  String get rawSign => '-';

  @override
  String get displaySign => '−';
}

class AltMinusOperator extends MinusOperator {
  @override
  String get rawSign => '−';
}

class MultiplicationOperator extends Operator {
  @override
  Result compute(ComputeContext context, Result leftHand, Result rightHand) =>
      leftHand * rightHand;

  @override
  Precedence get precedence => Precedence.multiplicative;

  @override
  String get rawSign => '*';

  @override
  String get displaySign => '×';
}

class AltMultiplicationOperator extends MultiplicationOperator {
  @override
  String get rawSign => '×';
}

class DivisionOperator extends Operator {
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
  String get rawSign => '/';

  @override
  String get displaySign => '÷';
}

class AltDivisionOperator extends DivisionOperator {
  @override
  String get rawSign => '÷';
}

class PowerOperator extends Operator {
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
