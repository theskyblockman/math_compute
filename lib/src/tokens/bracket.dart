import 'package:math_compute/src/lexing.dart';

/// Token types for opening brackets.
class OpeningBracket extends SimpleTokenType {
  /// Creates the token type.
  const OpeningBracket() : super('(', canBeFinal: false, isMultiChar: false);
}

/// Token types for closing brackets.
class ClosingBracket extends SimpleTokenType {
  /// Creates the token type.
  const ClosingBracket() : super(')', canBeFinal: true, isMultiChar: false);
}
