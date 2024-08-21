import 'dart:collection';

import 'package:logging/logging.dart';
import 'package:math_compute/base.dart';
import 'package:math_compute/src/computable.dart';

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
  int lastTokenSeparation = 0;
  int pos = 0;

  input = input.replaceAll(' ', '');

  List<Token> tokens = [];

  while (pos < input.length) {
    LinkedHashMap<TokenType, int> lengthPerToken = LinkedHashMap();
    for (TokenType type in context.registeredTokens) {
      pos = lastTokenSeparation;
      while (true) {
        final buildingToken = input.substring(lastTokenSeparation, pos + 1);

        final doesValidate = type.validateType(context,
            tokens.lastOrNull?.type ?? NoTokenType(), buildingToken, null);

        if (!type.isMultiChar || pos == input.length - 1) {
          if (doesValidate) {
            lengthPerToken[type] = buildingToken.length;
          } else {
            lengthPerToken[type] = buildingToken.length - 1;
          }
          break;
        }

        if (!doesValidate) {
          lengthPerToken[type] = buildingToken.length - 1;
          break;
        }

        pos++;
      }
    }

    final longest = lengthPerToken.entries.toList()
      ..removeWhere((element) => element.value == 0)
      ..sort((a, b) => b.value.compareTo(a.value));

    if (lengthPerToken.isEmpty) {
      throw ComputationError(ComputationStep.lexing,
          message: 'No tokens registered in context?');
    }

    while (true) {
      if (longest.isEmpty) {
        throw ComputationError(ComputationStep.lexing,
            message: 'No matching token found',
            globalPosition: lastTokenSeparation);
      }

      final currentLongest = longest.first;
      final buildingToken = input.substring(
          lastTokenSeparation, lastTokenSeparation + currentLongest.value);

      if (currentLongest.key.validate(
          context, tokens.lastOrNull ?? NoToken(), buildingToken, null)) {
        tokens.add(currentLongest.key
            .createToken(context, buildingToken, lastTokenSeparation));
        lastTokenSeparation = lastTokenSeparation + currentLongest.value;
        pos = lastTokenSeparation;
        break;
      } else {
        _log.finest(
            'Candidate deleted ${currentLongest.key.runtimeType.toString()}');
        longest.remove(currentLongest);
      }
    }
  }

  return tokens;
}
