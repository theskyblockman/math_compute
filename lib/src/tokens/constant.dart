import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/constants.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/lexing.dart';

/// The token type for constants.
class ConstantTokenType extends SimpleBanListValidator {
  /// Creates the token type.
  const ConstantTokenType()
      : super(
            bannedLeadingTokenTypes: const [],
            bannedTrailingTokenTypes: const []);

  @override
  bool get isMultiChar => true;

  @override
  bool additionalFactor(ComputeContext ctx, String rawBuildingToken) {
    return ctx.registeredConstants
        .any((element) => element.name.startsWith(rawBuildingToken));
  }

  @override
  Token<TokenType> createToken(
      ComputeContext ctx, String rawValue, int globalOffset) {
    return ConstantToken(
        ctx.registeredConstants
            .firstWhere((element) => element.name == rawValue),
        type: this,
        rawValue: rawValue,
        globalOffset: globalOffset);
  }
}

/// A token for constants.
class ConstantToken extends Token<ConstantTokenType> {
  /// Creates the token.
  ConstantToken(this.constant,
      {required super.type, required super.rawValue, super.globalOffset});

  /// The held constant.
  final Constant constant;

  @override
  Result compute(ComputeContext ctx) => constant.value;

  @override
  String toString() => constant.displayName ?? constant.name;
}
