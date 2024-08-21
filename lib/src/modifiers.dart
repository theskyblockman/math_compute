import 'package:math_compute/src/computation.dart';
import 'package:rational/rational.dart';

Rational factorial(Rational n) {
  var prod = Rational.one;
  for (var i = 1; i.toRational() <= n; i++) {
    prod *= i.toRational();
  }

  return prod;
}

abstract class Modifier {
  Result modify(Result input);

  Result modifyOnAdditiveOperation(Result current, Result other) => current;

  String get visualSign;

  Type? get requiredBefore => null;

  Type? get requiredAfter => null;
}

class FactorialModifier extends Modifier {
  FactorialModifier();

  @override
  Result modify(Result input) {
    return Result(
        dirtyParts: {},
        clean: factorial(Rational.parse(input.approximate().toString())));
  }

  @override
  String get visualSign => '!';
}

class PercentageModifier extends Modifier {
  PercentageModifier();

  @override
  Result modify(Result input) {
    return (input / Result(clean: Rational.fromInt(100)))
        .copyWith(modifier: this);
  }

  @override
  Result modifyOnAdditiveOperation(Result current, Result other) {
    return current * other;
  }

  @override
  String get visualSign => '%';
}
