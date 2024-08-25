import 'dart:math' as math;

import 'package:math_compute/base.dart';
import 'package:math_compute/src/constants.dart';

/// A cleaner sinus, rounds the known values.
double sin(num radians) {
  if (radians.abs() % math.pi < 1e-10) {
    return 0;
  }
  if (radians.abs() % (math.pi / 2) < 1e-10) {
    return 1;
  }
  if (radians.abs() < 1e-10) {
    return 0;
  }
  return math.sin(radians);
}

/// A cleaner cosinus, rounds the known values.
double cos(num radians) {
  if (radians.abs() % math.pi < 1e-10) {
    return -1;
  }
  if (radians.abs() % (math.pi / 2) < 1e-10) {
    return 0;
  }
  if (radians.abs() < 1e-10) {
    return 1;
  }
  return math.cos(radians);
}

/// A cleaner tangent, rounds the known values.
double tan(num radians) {
  double sinApprox = sin(radians);
  double cosApprox = cos(radians);

  if (cosApprox.abs() < 1e-10) {
    return double.infinity * sinApprox.sign;
  }

  return sinApprox / cosApprox;
}

/// A square root taking into account negative values.
Result sqrt(num input) {
  final result = math.sqrt(input.abs());

  if (input.sign == 1) {
    return Result(clean: Rational.parse(result.toString()));
  }

  return Result(dirtyParts: {IImaginaryValue(): result});
}

/// A cube root function.
Result cubeRoot(num input) {
  return Result(clean: Rational.parse(math.pow(input, 1 / 3).toString()));
}

/// A binary logarithm function.
double log2(num x) {
  return math.log(x) / math.log(2);
}

/// A logarithm function.
double log10(num x) {
  return math.log(x) / math.log(10);
}

/// A factorial function.
Rational factorial(Rational n) {
  var prod = Rational.one;
  for (var i = 1; i.toRational() <= n; i++) {
    prod *= i.toRational();
  }

  return prod;
}
