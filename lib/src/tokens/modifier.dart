import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/lexing.dart';
import 'package:math_compute/src/modifiers.dart';

class ModifierTokenType extends SimpleBanListValidator {
  const ModifierTokenType()
      : super(
            bannedTrailingTokenTypes: const [],
            bannedLeadingSelf: true,
            bannedLeadingTokenTypes: const [],
            bannedTrailingSelf: true);

  @override
  bool get isMultiChar => true;

  Modifier? _getModifier(ComputeContext ctx, String rawBuildingToken) {
    return ctx.registeredModifiers.cast<Modifier?>().firstWhere(
        (o) => o!.visualSign.startsWith(rawBuildingToken),
        orElse: () => null);
  }

  @override
  bool additionalFactor(ComputeContext ctx, String rawBuildingToken) {
    return ctx.registeredModifiers
            .any((m) => m.visualSign.startsWith(rawBuildingToken)) &&
        rawBuildingToken.isNotEmpty;
  }

  @override
  Token<TokenType> createToken(
      ComputeContext ctx, String rawValue, int globalOffset) {
    return ModifierToken(
        modifier: _getModifier(ctx, rawValue)!,
        type: this,
        rawValue: rawValue,
        globalOffset: globalOffset);
  }

  @override
  bool validatePreviousType(ComputeContext ctx, String rawBuildingToken,
      TokenType? previousTokenType) {
    if (!super.validatePreviousType(ctx, rawBuildingToken, previousTokenType)) {
      return false;
    }

    final modifier = _getModifier(ctx, rawBuildingToken)!;
    return previousTokenType?.runtimeType == modifier.requiredBefore ||
        modifier.requiredBefore == null;
  }

  @override
  bool validateNextType(
      ComputeContext ctx, String rawBuildingToken, TokenType? nextTokenType) {
    if (!super.validateNextType(ctx, rawBuildingToken, nextTokenType)) {
      return false;
    }

    final modifier = _getModifier(ctx, rawBuildingToken)!;
    return nextTokenType?.runtimeType == modifier.requiredAfter ||
        modifier.requiredAfter == null;
  }
}

class ModifierToken extends Token<ModifierTokenType> {
  ModifierToken(
      {required this.modifier,
      required super.type,
      required super.rawValue,
      super.globalOffset});

  final Modifier modifier;

  @override
  Result compute(ComputeContext ctx) => modifier.modify(Result.one());
}
