import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/errors.dart';
import 'package:math_compute/src/lexing.dart';
import 'package:rational/rational.dart';

/// The token type for numbers.
class NumberTokenType extends SimpleBanListValidator {
  /// Creates the token type.
  const NumberTokenType()
      : super(
            bannedLeadingTokenTypes: const [],
            bannedLeadingSelf: true,
            bannedTrailingTokenTypes: const [],
            bannedTrailingSelf: true);

  @override
  bool get isMultiChar => true;

  @override
  bool additionalFactor(ComputeContext ctx, String rawBuildingToken) {
    return rawBuildingToken.isNotEmpty &&
        ctx.numberChecker.hasMatch(rawBuildingToken);
  }

  @override
  Token<TokenType> createToken(
      ComputeContext ctx, String rawValue, int globalOffset) {
    try {
      return NumberToken(
          value: Result(clean: Rational.parse(rawValue)),
          type: this,
          rawValue: rawValue,
          globalOffset: globalOffset);
    } on FormatException catch (_) {
      throw ComputationError(ComputationStep.lexing,
          message: 'Number meaning ambiguous', globalPosition: globalOffset);
    }
  }
}

/// A token for numbers.
class NumberToken extends Token<NumberTokenType> {
  /// Creates the token.
  NumberToken(
      {required this.value,
      required super.type,
      required super.rawValue,
      super.globalOffset});

  /// The held value.
  final Result value;

  @override
  Result compute(ComputeContext ctx) => value;
}
