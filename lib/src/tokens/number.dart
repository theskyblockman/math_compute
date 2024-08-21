import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/errors.dart';
import 'package:rational/rational.dart';

import '../constants.dart';
import '../context.dart';
import '../lexing.dart';
import 'constant.dart';

class NumberTokenType extends SimpleBanListValidator {
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
      if (rawValue == 'e' || rawValue == '𝑒') {
        return ConstantToken(e, type: ConstantTokenType(), rawValue: rawValue);
      }

      throw ComputationError(ComputationStep.lexing,
          message: 'Number meaning ambiguous', globalPosition: globalOffset);
    }
  }
}

class NumberToken extends Token<NumberTokenType> {
  NumberToken(
      {required this.value,
      required super.type,
      required super.rawValue,
      super.globalOffset});

  final Result value;

  @override
  Result compute(ComputeContext ctx) => value;
}
