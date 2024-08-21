// This examples show all the steps made to compute an expression
// The part you want to look the most into is the ComputeContext class (and its
// default implementation) where you can change the parameters for
// the environment of the computation (constants, radians or degrees, etc.)

// Examples coming from https://en.wikipedia.org/wiki/Shunting_yard_algorithm#Detailed_examples

import 'package:math_compute/advanced.dart';
import 'package:math_compute/base.dart';

void main() {
  final input = '3 + 4 × 2 ÷ ( 1 − 5 ) ^ 2 ^ 3';
  print('Computing "$input"...');
  final tokens = separateTokens(input);
  print('Its tokens are ${tokens.map((e) => e.toString()).join()}');
  final rpn = toRPN(tokens);
  print(
      'Its Reverse Polish Notation is ${rpn.map((e) => e.rawValue).join(' ')}');
  final computable = rpnToComputable(rpn);
  print('Its computable form is ${computable.toString()}');
  final result = computable.compute(const DefaultComputeContext());
  print('The result is $result!');

  if (!result.approximable()) {
    print('This is not approximable to a double!');
    return;
  }

  final approximation = result.approximate();

  if (!approximation.isInteger) {
    if (approximation.hasFinitePrecision) {
      print('This is ${approximation.toDouble()}!');
    } else {
      print(
          'This is about ${approximation.toDouble()} but this isn\'t an exact value!');
    }
  }
}
