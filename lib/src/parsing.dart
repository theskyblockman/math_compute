import 'package:logging/logging.dart';
import 'package:math_compute/src/computable.dart';
import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/errors.dart';
import 'package:math_compute/src/lexing.dart';
import 'package:math_compute/src/math_compute_base.dart';
import 'package:math_compute/src/tokens/bracket.dart';
import 'package:math_compute/src/tokens/comma.dart';
import 'package:math_compute/src/tokens/constant.dart';
import 'package:math_compute/src/tokens/function.dart';
import 'package:math_compute/src/tokens/modifier.dart';
import 'package:math_compute/src/tokens/number.dart';
import 'package:math_compute/src/tokens/operator.dart';

final _log = Logger('Parser');

List<Token> _explicitMultiplications(ComputeContext ctx, List<Token> tokens) {
  // If a valid combinaison if found just add a multiplication token

  if (tokens.length < 2) {
    return tokens;
  }

  List<Token> processed = [];
  Token last = tokens.removeAt(0);

  while (tokens.isNotEmpty) {
    final current = tokens.removeAt(0);
    bool shouldAddMultiplication;
    switch (last.type) {
      case NumberTokenType _:
        {
          switch (current.type) {
            case ConstantTokenType _ || FunctionTokenType _:
              {
                shouldAddMultiplication = true;
              }
            default:
              {
                shouldAddMultiplication = false;
              }
          }
        }
      case ConstantTokenType _:
        {
          switch (current.type) {
            case ConstantTokenType _ || FunctionTokenType _:
              {
                shouldAddMultiplication = true;
              }
            default:
              {
                shouldAddMultiplication = false;
              }
          }
        }
      case ClosingBracket _:
        {
          switch (current.type) {
            case OpeningBracket _ ||
                  NumberTokenType _ ||
                  ConstantTokenType _ ||
                  FunctionTokenType _:
              {
                shouldAddMultiplication = true;
              }
            default:
              {
                shouldAddMultiplication = false;
              }
          }
        }
      default:
        {
          shouldAddMultiplication = false;
        }
    }

    processed.add(last);

    if (shouldAddMultiplication) {
      processed
          .add(OperatorTokenType().createToken(ctx, '*', last.globalOffset));
    }

    last = current;
  }

  processed.add(last);

  return processed;
}

// Based off of https://en.wikipedia.org/wiki/Shunting_yard_algorithm#The_algorithm_in_detail
List<Token> toRPN(List<Token> tokens,
    {ComputeContext context = const DefaultComputeContext()}) {
  List<Token> operatorStack = [];
  List<Token> outputQueue = [];

  _log.finest('Before adding implicit multiplication: $tokens');
  tokens = _explicitMultiplications(context, tokens);
  _log.finest('After adding implicit multiplication: $tokens');

  for (int i = 0; i < tokens.length; i++) {
    final token = tokens.elementAt(i);

    switch (token.type) {
      case NumberTokenType _:
        {
          outputQueue.add(token);
        }
      case ConstantTokenType _:
        {
          outputQueue.add(token);
        }
      case FunctionTokenType _:
        {
          operatorStack.add(token);
        }
      case ModifierTokenType _:
        {
          outputQueue.add(token);
        }
      case OperatorTokenType _:
        {
          final o1 = token as OperatorToken;
          Token? o2 = operatorStack.lastOrNull;
          while (o2 is OperatorToken &&
              (o2.operator.precedence.priority >
                      o1.operator.precedence.priority ||
                  (o1.operator.precedence.priority ==
                          o2.operator.precedence.priority &&
                      o1.operator.isLeftAssociative))) {
            outputQueue.add(operatorStack.removeLast());
            o2 = operatorStack.lastOrNull;
          }
          operatorStack.add(o1);
        }
      case Comma _:
        {
          while (operatorStack.last.type is! OpeningBracket) {
            outputQueue.add(operatorStack.removeLast());
          }
        }
      case OpeningBracket _:
        {
          operatorStack.add(token);
        }
      case ClosingBracket _:
        {
          if (operatorStack.isEmpty) {
            throw ComputationError(ComputationStep.parsing,
                message: "Tried to close a bracket that was not opened",
                globalPosition: token.globalOffset);
          }
          while (operatorStack.last.type is! OpeningBracket) {
            outputQueue.add(operatorStack.removeLast());
          }
          // Remove the opening bracket
          operatorStack.removeLast();
          if (operatorStack.lastOrNull?.type is FunctionTokenType) {
            outputQueue.add(operatorStack.removeLast());
          }
        }
    }

    _log.finest(
        "Token: ${token.rawValue} Output: ${outputQueue.map((e) => e.rawValue).join(' ')} Operator stack: ${operatorStack.map((e) => e.rawValue).join(' ')}");
  }

  while (operatorStack.isNotEmpty) {
    if (operatorStack.last.type is OpeningBracket) {
      throw ComputationError(ComputationStep.parsing,
          message: "Tried to close a bracket that was not opened",
          globalPosition: operatorStack.last.globalOffset);
    }
    outputQueue.add(operatorStack.removeLast());
  }

  _log.finest("Output: ${outputQueue.map((e) => e.rawValue).join(' ')}");

  return outputQueue;
}

Computable rpnToComputable(List<Token> tokens,
    {ComputeContext context = const DefaultComputeContext()}) {
  if (tokens.isEmpty) {
    return Result.zero();
  }

  final List<Computable> stack = [];
  for (final token in tokens) {
    _log.finest('Current token: $token Stack: $stack');
    if (token is OperatorToken) {
      if (stack.isEmpty) {
        throw ComputationError(ComputationStep.eval,
            message: "Tried to use operator ${token.rawValue} but no operands",
            globalPosition: token.globalOffset);
      }
      final rightHand = stack.removeLast();
      final Computable leftHand;
      if (stack.isEmpty) {
        leftHand = Result.zero();
      } else {
        leftHand = stack.removeLast();
      }

      stack.add(Expression(
          operator: token.operator, leftHand: leftHand, rightHand: rightHand));
    } else if (token is ModifierToken) {
      stack.add(token.modifier.modify(stack.removeLast().compute(context)));
    } else if (token is FunctionToken) {
      final arguments = List.generate(token.function.requiredParameterCount,
          (index) => stack.removeLast().compute(context));
      stack.add(token.function.compute(context, arguments));
    } else {
      stack.add(token);
    }
  }

  return stack.singleOrNull ?? tokens.single.compute(context);
}
