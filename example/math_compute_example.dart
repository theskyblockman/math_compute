import 'package:math_compute/base.dart';

void main() {
  // Example coming from https://en.wikipedia.org/wiki/Shunting_yard_algorithm#Detailed_examples
  final input = '5% + 100'; // 3 + 4 × 2 ÷ ( 1 − 5 ) ^ 2 ^ 3
  print('Computing "$input"...');
  final result = compute(input);

  if (!result.approximable()) {
    print('This is not approximable to a double!');
    return;
  }

  final approximation = result.approximate();
  print('The result is $result!');
  if (!approximation.isInteger) {
    if (approximation.hasFinitePrecision) {
      print('This is ${approximation.toDouble()}!');
    } else {
      print(
          'This is about ${approximation.toDouble()} but this isn\'t an exact value!');
    }
  }
}
