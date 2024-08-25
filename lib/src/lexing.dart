import 'dart:collection';

import 'package:logging/logging.dart';
import 'package:math_compute/base.dart';
import 'package:math_compute/src/computable.dart';

final _log = Logger('Lexer');

/// A token, a chain of characters representing a value to manage.
class Token<T extends TokenType> implements Computable {
  /// The type of the token.
  final T type;

  /// The raw value of the token.
  final String rawValue;

  /// Where the token is located.
  final int globalOffset;

  /// Creates the token.
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

/// A placeholder token type for when there are no tokens.
class NoTokenType extends TokenType {
  /// Creates the placeholder.
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

/// A placeholder token for when there are no tokens.
class NoToken extends Token {
  /// Creates the placeholder.
  const NoToken() : super(type: const NoTokenType(), rawValue: "");
}

/// A type of token, it is used to know exactly when to create the token.
abstract class TokenType {
  /// Signals the caller if the token type is compatible with the next type of
  /// token.
  bool validateNextType(
      ComputeContext ctx, String rawBuildingToken, TokenType? nextTokenType);

  /// Signals the caller if the token type is compatible with the next token.
  bool validateNext(
      ComputeContext ctx, String rawBuildingToken, Token? nextToken);

  /// Signals the caller is the token type is compatible with the previous type
  /// of token.
  bool validatePreviousType(ComputeContext ctx, String rawBuildingToken,
      TokenType? previousTokenType);

  /// Signals the caller if the token type is compatible with the previous
  /// token.
  bool validatePrevious(
      ComputeContext ctx, String rawBuildingToken, Token? previousToken);

  /// Signals the caller if the token type is compatible with the next and
  /// previous types of tokens.
  bool validateType(ComputeContext ctx, TokenType? previousTokenType,
      String rawBuildingToken, TokenType? nextTokenType) {
    return validatePreviousType(ctx, rawBuildingToken, previousTokenType) &&
        validateNextType(ctx, rawBuildingToken, nextTokenType);
  }

  /// Signals the caller if the token type is compatible with the next and
  /// previous tokens.
  bool validate(ComputeContext ctx, Token? previousToken,
      String rawBuildingToken, Token? nextToken) {
    return validatePrevious(ctx, rawBuildingToken, previousToken) &&
        validateNext(ctx, rawBuildingToken, nextToken);
  }

  /// Can the token be composed of multiple characters.
  bool get isMultiChar;

  /// Creates the token.
  Token createToken(ComputeContext ctx, String rawValue, int globalOffset);

  /// Creates the token type.
  const TokenType();
}

/// A helper class used to have a list of banned token types before and after
/// it among other things.
abstract class SimpleBanListValidator extends TokenType {
  /// Creates the validator.
  const SimpleBanListValidator({
    required this.bannedLeadingTokenTypes,
    this.bannedLeadingSelf = false,
    required this.bannedTrailingTokenTypes,
    this.bannedTrailingSelf = false,
  });

  /// A list containing all the banned token types before it.
  final List<TokenType> bannedLeadingTokenTypes;

  /// Can the leading token be the same as this.
  final bool bannedLeadingSelf;

  /// Can the leading token be null.
  bool get leadingCanBeNull => true;

  /// A list containing all the banned token types after it.
  final List<TokenType> bannedTrailingTokenTypes;

  /// Can the trailing token be the same as this.
  final bool bannedTrailingSelf;

  /// Cab the trailing token be null.
  bool get trailingCanBeNull => true;

  /// An external additional factor,
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

/// A helper mixing to create simple tokens which cannot be computed
mixin SimpleTokenCreator on TokenType {
  @override
  Token<TokenType> createToken(
      ComputeContext ctx, String rawValue, int globalOffset) {
    return Token(type: this, rawValue: rawValue, globalOffset: globalOffset);
  }
}

/// Helper class to create simple tokens which cannot be computed
class SimpleTokenType extends SimpleBanListValidator with SimpleTokenCreator {
  /// Creates the token type.
  const SimpleTokenType(this.charToMatchAgainst,
      {required this.canBeFinal, required this.isMultiChar})
      : super(
            bannedLeadingTokenTypes: const [],
            bannedTrailingTokenTypes: const []);

  /// Can the token be the last one to be created.
  final bool canBeFinal;
  @override
  final bool isMultiChar;

  /// The character to match against.
  final String charToMatchAgainst;

  @override
  bool additionalFactor(ComputeContext ctx, String rawBuildingToken) {
    return charToMatchAgainst.startsWith(rawBuildingToken) &&
        (rawBuildingToken.length == 1 || isMultiChar);
  }
}

/// Does a lexical analysis by splitting the input into tokens.
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
