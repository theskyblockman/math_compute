import 'package:math_compute/src/constants.dart';
import 'package:math_compute/src/functions.dart';
import 'package:math_compute/src/functions/compare.dart';
import 'package:math_compute/src/functions/exponential.dart';
import 'package:math_compute/src/functions/logarithms.dart';
import 'package:math_compute/src/functions/roots.dart';
import 'package:math_compute/src/functions/triangulation.dart';
import 'package:math_compute/src/lexing.dart';
import 'package:math_compute/src/modifiers.dart';
import 'package:math_compute/src/operators.dart';
import 'package:math_compute/src/tokens/bracket.dart';
import 'package:math_compute/src/tokens/comma.dart';
import 'package:math_compute/src/tokens/constant.dart';
import 'package:math_compute/src/tokens/function.dart';
import 'package:math_compute/src/tokens/modifier.dart';
import 'package:math_compute/src/tokens/number.dart';
import 'package:math_compute/src/tokens/operator.dart';

abstract class ComputeContext {
  /// A list of operators, defaults to basic operators (plus, minus, etc.)
  /// A list of token types, defaults to basic token types (numbers, operators,
  /// brackets, etc.)
  ///
  /// **The order in which those tokens are registered affects their
  /// priority**
  List<TokenType> get registeredTokens;

  List<Operator> get registeredOperators;

  List<Constant> get registeredConstants;

  List<MathFunction> get registeredFunctions;

  /// A list of modifiers, defaults to basic modifiers (factorials, plus,
  /// minus etc.)
  List<Modifier> get registeredModifiers;

  /// Needed to check if a char can be part of a number (defaults to digits,
  /// "." and exponents.)
  RegExp get numberChecker;

  /// Needed to check if a char can be part of a call (defaults to the
  /// latin alphabet.)
  RegExp get letterChecker;

  /// When using functions asking for angles, automatically convert the degrees
  /// to radians to compute them.
  bool get convertDegreesToRadians;
}

class DefaultComputeContext implements ComputeContext {
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
  List<Constant> get registeredConstants => [pi, altPi, i, e];

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
  List<Modifier> get registeredModifiers => [factorial, percentage];

  /// Based off of [Rational]'s parsing regex (edited)
  @override
  RegExp get numberChecker => RegExp(r'^\d+\.?\d*([eE][+-]?\d*)?$');

  @override
  RegExp get letterChecker => RegExp(r'^[a-zA-Z]+$');

  @override
  final bool convertDegreesToRadians;

  const DefaultComputeContext({this.convertDegreesToRadians = true});
}
