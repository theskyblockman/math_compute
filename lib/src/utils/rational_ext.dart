import 'package:rational/rational.dart';

/// A small snippet of code made to know if a rational has a finite precision.
///
/// Copyright 2013 Alexandre Ardhuin
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///     http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
extension RationalExt on Rational {
  /// Checks if the fraction can be translated exactly to a floating point
  /// number.
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

// Copy of the license
