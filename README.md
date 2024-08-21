# Math lexer/parser/evaluator

A highly customizable and easy to use math expression lexer/parser/evaluator

## Features

- Comprehensible error system with originating token
- Customizable math context
  - Custom token types
  - Custom constants
  - Custom functions
  - Custom operators
- Token constructors and validators aware of surrounding tokens in lexer
- Parser to Reverse Polish Notation
- Parser to compute tree
- Simple to use recursively-based evaluator
  

## Getting started

Add this package to your Dart/Flutter project via
```bash
dart pub add math_parser
```
or
```bash
flutter pub add math_parser
```

## Usage

> _You can find samples in the example page._

To compute an expression, simply put it in the "compute" function:
```dart
final result = compute('2 + 2');
print(result); // 4
```

## Additional information

If I was able to write this package myself it is thanks to Thorsten Ball's "Writing an interpreter in Go". I recommend
this book for any projects like this.

