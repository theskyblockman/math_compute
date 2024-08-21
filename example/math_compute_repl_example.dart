import 'dart:convert';
import 'dart:io';

import 'package:math_compute/base.dart';

void main() {
  print('Welcome to your very own calculator! Write an expression to start');

  while (true) {
    stdout.write('>>> ');
    final rawExpression = stdin.readLineSync(encoding: utf8);
    if (rawExpression == null || rawExpression.isEmpty) {
      continue;
    }

    try {
      final result = compute(rawExpression);
      stdout.write(result.toString());
      if (result.approximable()) {
        final approximation = result.approximate();
        if (!approximation.isInteger) {
          stdout.write('≈${approximation.toDouble()}');
        }
      }
    } on ComputationError catch (e) {
      stdout.write(null);
      stderr.writeln("Couldn't compute expression... ${e.toString()}");
      stderr.flush();
    }
    stdout.writeln();
  }
}
