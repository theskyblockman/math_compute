import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/errors.dart';
import 'package:math_compute/src/lexing.dart';

import '../functions.dart';

class FunctionTokenType extends SimpleBanListValidator {
  const FunctionTokenType()
      : super(
            bannedLeadingTokenTypes: const [],
            bannedLeadingSelf: true,
            bannedTrailingTokenTypes: const []);

  @override
  bool additionalFactor(ComputeContext ctx, String rawBuildingToken) {
    return ctx.registeredFunctions
        .any((element) => element.name.startsWith(rawBuildingToken));
  }

  @override
  bool get isMultiChar => true;

  @override
  Token<TokenType> createToken(
      ComputeContext ctx, String rawValue, int globalOffset) {
    return FunctionToken(ctx,
        type: this, rawValue: rawValue, globalOffset: globalOffset);
  }
}

class FunctionToken extends Token<FunctionTokenType> {
  FunctionToken(ComputeContext context,
      {required super.type, required super.rawValue, super.globalOffset}) {
    for (final f in context.registeredFunctions) {
      if (f.name == rawValue) {
        function = f;
        return;
      }
    }

    throw ComputationError(ComputationStep.lexing,
        message: 'Unknown function "$rawValue"', globalPosition: globalOffset);
  }

  late final MathFunction function;

  @override
  String toString() {
    return function.displayName;
  }
}
