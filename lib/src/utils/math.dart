import 'dart:math' as math;

import 'package:math_compute/base.dart';
import 'package:math_compute/src/constants.dart';

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

double tan(num radians) {
  double sinApprox = sin(radians);
  double cosApprox = cos(radians);

  if (cosApprox.abs() < 1e-10) {
    return double.infinity * sinApprox.sign;
  }

  return sinApprox / cosApprox;
}

Result sqrt(num input) {
  final result = math.sqrt(input.abs());

  if (input.sign == 1) {
    return Result(clean: Rational.parse(result.toString()));
  }

  return Result(dirtyParts: {IImaginaryValue(): result});
}

Result cubeRoot(num input) {
  return Result(clean: Rational.parse(math.pow(input, 1 / 3).toString()));
}

double log2(num x) {
  return math.log(x) / math.log(2);
}

double log10(num x) {
  return math.log(x) / math.log(10);
}
