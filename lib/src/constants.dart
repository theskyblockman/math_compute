import 'dart:math' as math;

import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/math_compute_base.dart';
import 'package:rational/rational.dart';

class Constant {
  final Result value;
  final String name;
  final String? displayName;

  const Constant(this.name, this.value, {this.displayName});
}

class PiValue extends ImaginaryValue {
  @override
  Rational approximate([int? digits]) => Rational.parse(math.pi.toString());

  @override
  String get representation => 'π';

  const PiValue();
}

final pi = Constant('pi', Result(dirtyParts: {PiValue(): 1}), displayName: 'π');
final altPi =
    Constant('π', Result(dirtyParts: {PiValue(): 1}), displayName: 'π');

class RationalImaginaryValue extends ImaginaryValue {
  final Rational rational;

  const RationalImaginaryValue(this.rational);

  @override
  Rational approximate([int? digits]) => rational;

  @override
  String get representation {
    return switch (rational.toString()) {
      '1' => '½',
      '1/2' => '⅓',
      '1/5' => '⅕',
      '1/6' => '⅙',
      '1/8' => '⅛',
      '2/3' => '⅔',
      '2/5' => '⅖',
      '5/6' => '⅚',
      '3/8' => '⅜',
      '3/4' => '¾',
      '3/5' => '⅗',
      '5/8' => '⅝',
      '7/8' => '⅞',
      '4/5' => '⅘',
      '1/4' => '¼',
      '1/7' => '⅐',
      '1/9' => '⅑',
      '1/10' => '⅒',
      _ => rational.toString()
    };
  }

  @override
  int get hashCode => rational.hashCode;

  @override
  bool operator ==(Object other) {
    return other is RationalImaginaryValue && other.rational == rational;
  }
}

class IImaginaryValue extends ImaginaryValue {
  @override
  // This should NOT be approximated
  Rational approximate([int? digits]) => Rational.fromInt(0);

  @override
  bool get approximable => false;

  @override
  String get representation => '𝑖';

  const IImaginaryValue();
}

final i = Constant('i', Result(dirtyParts: {IImaginaryValue(): 1}),
    displayName: '𝑖');

class EImaginaryValue extends ImaginaryValue {
  @override
  Rational approximate([int? digits]) => Rational.parse(math.e.toString());

  @override
  String get representation => '𝑒';

  const EImaginaryValue();
}

final e = Constant('e', Result(dirtyParts: {EImaginaryValue(): 1}),
    displayName: '𝑒');
