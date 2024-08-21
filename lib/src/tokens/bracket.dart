import 'package:math_compute/src/lexing.dart';

class OpeningBracket extends SimpleTokenType {
  const OpeningBracket() : super('(', canBeFinal: false, isMultiChar: false);
}

class ClosingBracket extends SimpleTokenType {
  const ClosingBracket() : super(')', canBeFinal: true, isMultiChar: false);
}
