import 'package:logging/logging.dart';
import 'package:math_compute/src/computable.dart';
import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/context.dart';

final _log = Logger('Lexer');

class Token<T extends TokenType> implements Computable {
  final T type;
  final String rawValue;
  final int globalOffset;

  const Token(
      {required this.type, required this.rawValue, this.globalOffset = -1});

  @override
  Result compute(ComputeContext ctx) {
    throw UnimplementedError('Generic tokens are not made to be computed');
  }

  @override
  String toString() {
    return rawValue;
  }
}

class NoTokenType extends TokenType {
  const NoTokenType();

  @override
  Token<TokenType> createToken(
      ComputeContext ctx, String rawValue, int globalOffset) {
    throw UnimplementedError();
  }

  @override
  bool get isMultiChar => throw UnimplementedError();

  @override
  bool validateNext(ComputeContext ctx, String rawBuildingToken,
          Token<TokenType>? nextToken) =>
      throw UnimplementedError();

  @override
  bool validateNextType(ComputeContext ctx, String rawBuildingToken,
          TokenType? nextTokenType) =>
      throw UnimplementedError();

  @override
  bool validatePrevious(ComputeContext ctx, String rawBuildingToken,
          Token<TokenType>? previousToken) =>
      throw UnimplementedError();

  @override
  bool validatePreviousType(ComputeContext ctx, String rawBuildingToken,
          TokenType? previousTokenType) =>
      throw UnimplementedError();
}

class NoToken extends Token {
  const NoToken() : super(type: const NoTokenType(), rawValue: "");
}

abstract class TokenType {
  bool validateNextType(
      ComputeContext ctx, String rawBuildingToken, TokenType? nextTokenType);

  bool validateNext(
      ComputeContext ctx, String rawBuildingToken, Token? nextToken);

  bool validatePreviousType(ComputeContext ctx, String rawBuildingToken,
      TokenType? previousTokenType);

  bool validatePrevious(
      ComputeContext ctx, String rawBuildingToken, Token? previousToken);

  bool validateType(ComputeContext ctx, TokenType? previousTokenType,
      String rawBuildingToken, TokenType? nextTokenType) {
    return validatePreviousType(ctx, rawBuildingToken, previousTokenType) &&
        validateNextType(ctx, rawBuildingToken, nextTokenType);
  }

  bool validate(ComputeContext ctx, Token? previousToken,
      String rawBuildingToken, Token? nextToken) {
    return validatePrevious(ctx, rawBuildingToken, previousToken) &&
        validateNext(ctx, rawBuildingToken, nextToken);
  }

  bool get isMultiChar;

  Token createToken(ComputeContext ctx, String rawValue, int globalOffset);

  const TokenType();
}

abstract class SimpleBanListValidator extends TokenType {
  const SimpleBanListValidator({
    required this.bannedLeadingTokenTypes,
    this.bannedLeadingSelf = false,
    required this.bannedTrailingTokenTypes,
    this.bannedTrailingSelf = false,
  });

  final List<TokenType> bannedLeadingTokenTypes;
  final bool bannedLeadingSelf;

  bool get leadingCanBeNull => true;

  final List<TokenType> bannedTrailingTokenTypes;

  bool get trailingCanBeNull => true;
  final bool bannedTrailingSelf;

  bool additionalFactor(ComputeContext ctx, String rawBuildingToken) => true;

  @override
  bool validateNextType(ComputeContext ctx, String rawBuildingToken,
          TokenType? nextTokenType) =>
      (trailingCanBeNull || nextTokenType != null) &&
      !bannedTrailingTokenTypes.contains(nextTokenType) &&
      (bannedTrailingSelf ? nextTokenType.runtimeType != runtimeType : true) &&
      additionalFactor(ctx, rawBuildingToken);

  @override
  bool validateNext(ComputeContext ctx, String rawBuildingToken,
          Token<TokenType>? nextToken) =>
      validateNextType(ctx, rawBuildingToken, nextToken?.type);

  @override
  bool validatePreviousType(ComputeContext ctx, String rawBuildingToken,
          TokenType? previousTokenType) =>
      (leadingCanBeNull || previousTokenType != null) &&
      !bannedLeadingTokenTypes.contains(previousTokenType) &&
      (bannedLeadingSelf
          ? previousTokenType.runtimeType.toString() != runtimeType.toString()
          : true) &&
      additionalFactor(ctx, rawBuildingToken);

  @override
  bool validatePrevious(ComputeContext ctx, String rawBuildingToken,
          Token<TokenType>? previousToken) =>
      validatePreviousType(ctx, rawBuildingToken, previousToken?.type);
}

mixin SimpleTokenCreator on TokenType {
  @override
  Token<TokenType> createToken(
      ComputeContext ctx, String rawValue, int globalOffset) {
    return Token(type: this, rawValue: rawValue, globalOffset: globalOffset);
  }
}

/// Helper class to create simple tokens which cannot be computed
class SimpleTokenType extends SimpleBanListValidator with SimpleTokenCreator {
  const SimpleTokenType(this.charToMatchAgainst,
      {required this.canBeFinal, required this.isMultiChar})
      : super(
            bannedLeadingTokenTypes: const [],
            bannedTrailingTokenTypes: const []);

  final bool canBeFinal;
  @override
  final bool isMultiChar;

  final String charToMatchAgainst;

  @override
  bool additionalFactor(ComputeContext ctx, String rawBuildingToken) {
    return charToMatchAgainst.startsWith(rawBuildingToken) &&
        (rawBuildingToken.length == 1 || isMultiChar);
  }
}

List<Token> separateTokens(String input,
    {ComputeContext context = const DefaultComputeContext()}) {
  int lastModeUpdate = 0;
  int pos = 0;

  List<Token> tokens = [];
  TokenType? currentTokenType;
  input = input.replaceAll(' ', '');
  while (pos < input.length) {
    final buildingToken = input.substring(lastModeUpdate, pos + 1);
    _log.finest('Building Token $buildingToken');

    final TokenType? possiblePreviousTokenType =
        tokens.isEmpty ? null : tokens.last.type;

    // Predict potential next token
    final String nextCharacter = (pos + 1 < input.length) ? input[pos + 1] : '';
    TokenType? predictedNextTokenType;
    for (var tokenType in context.registeredTokens) {
      if (tokenType.validate(context, null, nextCharacter, null)) {
        predictedNextTokenType = tokenType;
        break;
      }
    }

    _log.finest('Possible Previous ${possiblePreviousTokenType.runtimeType}');
    _log.finest('Predicting ${predictedNextTokenType.runtimeType}');

    if (currentTokenType == null) {
      // Find a matching token type
      for (var tokenType in context.registeredTokens) {
        if (tokenType.validateType(context, possiblePreviousTokenType,
            buildingToken, predictedNextTokenType)) {
          currentTokenType = tokenType;
          break;
        }
      }
    } else {
      // Check if the current type still matches
      if (!currentTokenType.validateType(context, possiblePreviousTokenType,
          buildingToken, predictedNextTokenType)) {
        final createdToken = currentTokenType.createToken(
            context, input.substring(lastModeUpdate, pos), lastModeUpdate);
        tokens.add(createdToken);

        currentTokenType = null;
        lastModeUpdate = pos;
        pos--;
      }
    }

    pos++;
  }

  if (currentTokenType != null) {
    final createdToken = currentTokenType.createToken(
        context, input.substring(lastModeUpdate, pos), lastModeUpdate);
    tokens.add(createdToken);
  }

  return tokens;
}
