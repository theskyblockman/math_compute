import 'package:math_compute/src/constants.dart';
import 'package:math_compute/src/functions.dart';
import 'package:math_compute/src/functions/compare.dart';
import 'package:math_compute/src/functions/exponential.dart';
import 'package:math_compute/src/functions/logarithms.dart';
import 'package:math_compute/src/functions/roots.dart';
import 'package:math_compute/src/functions/triangulation.dart';
import 'package:math_compute/src/lexing.dart';
import 'package:math_compute/src/tokens/bracket.dart';
import 'package:math_compute/src/tokens/comma.dart';
import 'package:math_compute/src/tokens/constant.dart';
import 'package:math_compute/src/tokens/number.dart';
import 'package:math_compute/src/tokens/operator.dart';

import 'modifiers.dart';
import 'operators.dart';
import 'tokens/function.dart';
import 'tokens/modifier.dart';

abstract class ComputeContext {
  /// A list of operators, defaults to basic operators (plus, minus, etc.)
  List<Operator> get registeredOperators;

  /// A list of modifiers, defaults to basic modifiers (factorials, plus,
  /// minus etc.)
  List<Modifier> get registeredModifiers;

  /// A list of token types, defaults to basic token types (numbers, operators,
  /// brackets, etc.)
  ///
  /// **The order in which those tokens are registered affects their
  /// priority**
  List<TokenType> get registeredTokens;

  List<MathFunction> get registeredFunctions;

  List<Constant> get registeredConstants;

  /// Needed to check if a char can be part of a number (defaults to digits
  /// and ".")
  RegExp get numberChecker;

  /// Needed to check if a char can be part of a call (defaults to the
  /// latin alphabet)
  RegExp get letterChecker;
}

class DefaultComputeContext implements ComputeContext {
  @override
  List<Operator> get registeredOperators => [
        PlusOperator(),
        MinusOperator(),
        AltMinusOperator(),
        MultiplicationOperator(),
        AltMultiplicationOperator(),
        DivisionOperator(),
        AltDivisionOperator(),
        PowerOperator(),
      ];

  @override
  List<Modifier> get registeredModifiers =>
      [FactorialModifier(), PercentageModifier()];

  @override
  List<TokenType> get registeredTokens => [
        NumberTokenType(),
        ModifierTokenType(),
        OperatorTokenType(),
        ConstantTokenType(),
        FunctionTokenType(),
        OpeningBracket(),
        ClosingBracket(),
        Comma()
      ];

  @override
  List<MathFunction> get registeredFunctions => [
        // Comparators
        min,
        max,
        // Exponential
        exp,
        // Logarithms
        log,
        ln,
        log2,
        lb,
        // Roots
        sqrt,
        sqrtAlt,
        cubeRoot,
        cubeRootAlt,
        // Triangulation
        sin,
        arcsin,
        asin,
        asn,
        cos,
        arccos,
        acos,
        acs,
        tan,
        arctan,
        atan,
      ];

  @override
  List<Constant> get registeredConstants => [pi, altPi, i, e];

  @override

  /// Based off of [Rational] (edited)
  RegExp get numberChecker => RegExp(r'^\d*\.?\d*([eE][+-]?\d*)?$');

  @override
  RegExp get letterChecker => RegExp(r'^[a-zA-Z]+$');

  const DefaultComputeContext();
}
