import 'package:math_compute/src/computation.dart';
import 'package:math_compute/src/utils/math.dart' as internal_math;
import 'package:rational/rational.dart';

/// A modifier is a token put in front of a number, it is an operator with only
/// one parameter.
abstract class Modifier {
  /// Creates the modifier.
  const Modifier();

  /// Modifies the input.
  Result modify(Result input);

  /// Modifies the input when it is an additive operation.
  Result modifyOnAdditiveOperation(Result current, Result other) => current;

  /// The visual sign of the modifier.
  String get visualSign;

  /// The token type required before this.
  Type? get requiredBefore => null;

  /// The token type required after this.
  Type? get requiredAfter => null;
}

/// A modifier for factorials
const factorial = _FactorialModifier();

class _FactorialModifier extends Modifier {
  const _FactorialModifier();

  @override
  Result modify(Result input) {
    return Result(
        dirtyParts: {},
        clean: internal_math
            .factorial(Rational.parse(input.approximate().toString())));
  }

  @override
  String get visualSign => '!';
}

/// A modifier for percentages
const percentage = _PercentageModifier();

class _PercentageModifier extends Modifier {
  const _PercentageModifier();

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
