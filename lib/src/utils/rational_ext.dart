import 'package:rational/rational.dart';

/// This comes from https://github.com/a14n/dart-decimal
/// Available under the Apache License 2.0 (license already present in the
/// package rational)
extension RationalExt on Rational {
  bool get hasFinitePrecision {
    // the denominator should only be a product of powers of 2 and 5
    var den = denominator;
    while (den % BigInt.from(5) == BigInt.zero) {
      den = den ~/ BigInt.from(5);
    }
    while (den % BigInt.two == BigInt.zero) {
      den = den ~/ BigInt.two;
    }
    return den == BigInt.one;
  }
}
