import 'dart:math' as math;

import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/math_compute_base.dart';
import 'package:rational/rational.dart';

/// A constant, a number that doesn't change.
class Constant {
  /// The value of the constant.
  final Result value;

  /// Its name (for the lexical analysis.)
  final String name;

  /// Its display name (for display.)
  final String? displayName;

  /// Creates a constant.
  const Constant(this.name, this.value, {this.displayName});
}

/// The imaginary value π.
class PiValue extends ImaginaryValue {
  @override
  Rational approximate([int? digits]) => Rational.parse(math.pi.toString());

  @override
  String get representation => 'π';

  /// Creates the imaginary value.
  const PiValue();
}

/// The constant π when written as "pi".
final pi = Constant('pi', Result(dirtyParts: {PiValue(): 1}), displayName: 'π');

/// The constant π when written as "π".
final altPi =
    Constant('π', Result(dirtyParts: {PiValue(): 1}), displayName: 'π');

/// The imaginary value representing a fraction.
class RationalImaginaryValue extends ImaginaryValue {
  /// The held rational.
  final Rational rational;

  /// Creates the imaginary value.
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

/// The imaginary value representing an imaginary number.
class IImaginaryValue extends ImaginaryValue {
  @override
  // This should NOT be approximated
  Rational approximate([int? digits]) => Rational.fromInt(0);

  @override
  bool get approximable => false;

  @override
  String get representation => '𝑖';

  /// Creates the imaginary value.
  const IImaginaryValue();
}

/// The constant i when written as "i".
final i = Constant('i', Result(dirtyParts: {IImaginaryValue(): 1}),
    displayName: '𝑖');

/// The imaginary value representing e.
class EImaginaryValue extends ImaginaryValue {
  @override
  Rational approximate([int? digits]) => Rational.parse(math.e.toString());

  @override
  String get representation => '𝑒';

  /// Creates the imaginary value.
  const EImaginaryValue();
}

/// The constant e when written as "e".
final e = Constant('e', Result(dirtyParts: {EImaginaryValue(): 1}),
    displayName: '𝑒');

/// The constant e when written as "𝑒".
final eAlt = Constant('𝑒', Result(dirtyParts: {EImaginaryValue(): 1}),
    displayName: '𝑒');
