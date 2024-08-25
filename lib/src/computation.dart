import 'package:math_compute/src/computable.dart';
import 'package:math_compute/src/context.dart';
import 'package:math_compute/src/lexing.dart';
import 'package:math_compute/src/math_compute_base.dart';
import 'package:math_compute/src/modifiers.dart';
import 'package:math_compute/src/parsing.dart';
import 'package:math_compute/src/utils/rational_ext.dart';
import 'package:rational/rational.dart';

/// Represents a real number and its imaginary parts.
class Result implements Computable {
  /// The clean, real value.
  late final Rational clean;

  /// The imaginary parts.
  final Map<ImaginaryValue, num> dirtyParts;

  /// The modifier, this is only kept to help the other operators.
  final Modifier? modifier;

  /// Creates the result.
  Result({Rational? clean, this.dirtyParts = const {}, this.modifier}) {
    this.clean = clean ?? Rational.zero;
  }

  /// The result of zero.
  Result.zero()
      : clean = Rational.zero,
        dirtyParts = const {},
        modifier = null;

  /// The result of one.
  Result.one()
      : clean = Rational.one,
        dirtyParts = const {},
        modifier = null;

  /// Creates a copy of the result with edits.
  Result copyWith(
      {Rational? clean,
      Map<ImaginaryValue, num>? dirtyParts,
      Modifier? modifier}) {
    return Result(
        clean: clean ?? this.clean,
        dirtyParts: dirtyParts ?? this.dirtyParts,
        modifier: modifier ?? this.modifier);
  }

  Map<ImaginaryValue, num> _mergeDirtyParts(
      Map<ImaginaryValue, num> other, num Function(num a, num b) compute,
      {Map<ImaginaryValue, num>? current}) {
    Map<ImaginaryValue, num> newDirtyParts = {};
    for (var MapEntry(key: value, value: amount) in [
      ...(current?.entries ?? dirtyParts.entries),
      ...other.entries
    ]) {
      if (newDirtyParts.containsKey(value)) {
        newDirtyParts[value] = compute(newDirtyParts[value]!, amount);
      } else {
        newDirtyParts[value] = amount;
      }
    }

    return newDirtyParts;
  }

  /// Adds two results together.
  operator +(Result other) {
    Result current = this;
    if (modifier != null) {
      current = modifier!.modifyOnAdditiveOperation(current, other);
    }

    if (other.modifier != null) {
      other = other.modifier!.modifyOnAdditiveOperation(other, current);
    }

    return Result(
        clean: current.clean + other.clean,
        dirtyParts: _mergeDirtyParts(other.dirtyParts, (a, b) => a + b,
            current: current.dirtyParts));
  }

  /// Subtracts two results.
  operator -(Result other) {
    Result current = this;
    if (modifier != null) {
      current = modifier!.modifyOnAdditiveOperation(this, other);
    }

    if (other.modifier != null) {
      other = other.modifier!.modifyOnAdditiveOperation(other, this);
    }

    return Result(
        clean: current.clean - other.clean,
        dirtyParts: _mergeDirtyParts(other.dirtyParts, (a, b) => a - b,
            current: current.dirtyParts));
  }

  /// Multiplies two results.
  operator *(Result other) =>
      Result(clean: approximate() * other.approximate());

  /// Divides two results.
  operator /(Result other) =>
      Result(clean: approximate() / other.approximate());

  /// Raises a result to a power.
  operator ^(Result other) {
    return Result(
        clean: approximate().pow(other.approximate().round().toInt()));
  }

  @override
  bool operator ==(Object other) {
    return other is Result &&
        clean == other.clean &&
        dirtyParts.length == other.dirtyParts.length &&
        dirtyParts.entries.every((e) =>
            other.dirtyParts.containsKey(e.key) &&
            other.dirtyParts[e.key] == dirtyParts[e.key]);
  }

  @override
  Result compute(ComputeContext ctx) => this;

  /// Approximate the result to a fraction.
  Rational approximate([int? digits]) {
    if (dirtyParts.isEmpty) {
      return clean;
    }

    return dirtyParts.entries.fold(
        clean,
        (previousValue, element) =>
            previousValue +
            element.key.approximate(digits) *
                Rational.parse(element.value.toString()));
  }

  /// Is the result approximable?
  bool approximable() =>
      clean.hasFinitePrecision &&
      dirtyParts.entries.every((iv) => iv.key.approximable || iv.value == 0);

  @override
  int get hashCode => Object.hash(clean, dirtyParts);

  @override
  String toString() {
    String builder = clean == Rational.zero ? '' : clean.toString();
    for (final dirtyPart in dirtyParts.entries) {
      builder += (dirtyPart.value.sign == 1 ? '+' : '-');
      if (dirtyPart.value.abs() != 1) {
        final quantity = dirtyPart.value.abs();
        if (quantity.round() == quantity) {
          builder += quantity.toInt().toString();
        } else {
          builder += quantity.toString();
        }
      }
      builder += dirtyPart.key.representation;
    }
    if (clean == Rational.zero) {
      if (dirtyParts.isEmpty) {
        builder = '0';
      } else if (builder.startsWith('+')) {
        builder = builder.substring(1);
      }
    }
    return builder;
  }
}

/// Takes an [input] expression and returns its result.
///
/// It does the following:
/// - Does a lexical analysis by splitting the expression in tokens (lexing)
/// - Sorts the tokens and removes parenthesis to turn the expression in Reverse Polish Notation
/// - Creates a tree from this RPN
/// - Computes the tree
///
/// We give the [context] throughout all of the process, we take all relevant
/// data like constants from it and can change the output.
Result compute(String input,
    {ComputeContext context = const DefaultComputeContext()}) {
  return rpnToComputable(
          toRPN(separateTokens(input, context: context), context: context),
          context: context)
      .compute(context);
}
