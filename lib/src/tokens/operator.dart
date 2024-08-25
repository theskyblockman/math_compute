import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/lexing.dart';
import 'package:math_compute/src/math_compute_base.dart';
import 'package:math_compute/src/operators.dart';

/// The token type for operators.
class OperatorTokenType extends SimpleBanListValidator {
  /// Creates the token type.
  const OperatorTokenType()
      : super(
            bannedTrailingTokenTypes: const [],
            bannedLeadingTokenTypes: const []);

  @override
  bool get isMultiChar => false;

  @override
  bool additionalFactor(ComputeContext ctx, String rawBuildingToken) {
    return ctx.registeredOperators.any((o) => o.rawSign == rawBuildingToken);
  }

  @override
  bool validateNext(ComputeContext ctx, String rawBuildingToken,
      Token<TokenType>? nextToken) {
    if (!super.validateNext(ctx, rawBuildingToken, nextToken)) {
      return false;
    }

    return nextToken == null ||
        (nextToken is OperatorToken &&
            nextToken.operator.precedence == Precedence.additive);
  }

  @override
  Token<TokenType> createToken(
      ComputeContext ctx, String rawValue, int globalOffset) {
    return OperatorToken(ctx,
        type: this, rawValue: rawValue, globalOffset: globalOffset);
  }
}

/// A token for operators.
class OperatorToken extends Token<OperatorTokenType> {
  /// Creates the token.
  OperatorToken(ComputeContext context,
      {required super.type, required super.rawValue, super.globalOffset}) {
    for (final op in context.registeredOperators) {
      if (op.rawSign == rawValue) {
        operator = op;
        break;
      }
    }
  }

  /// The held operator.
  late final Operator operator;

  @override
  String toString() => operator.displaySign;
}
