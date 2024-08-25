import 'package:math_compute/src/lexing.dart';

/// Token types for commas.
class Comma extends SimpleTokenType {
  /// Creates the token type.
  const Comma() : super(',', canBeFinal: false, isMultiChar: false);
}
