import 'package:math_compute/src/lexing.dart';

class Comma extends SimpleTokenType {
  const Comma() : super(',', canBeFinal: false, isMultiChar: false);
}
