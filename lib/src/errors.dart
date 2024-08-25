/// A list computation steps used to evaluate an expression.
enum ComputationStep {
  /// Lexing or Lexical Analysis splits the raw input into parts named tokens.
  lexing("lexing"),

  /// Parsing rearranges and validates the tokens.
  parsing("parsing"),

  /// Evaluating computes the expression into a result.
  eval("evaluating");

  /// Thw word to use when used
  final String word;

  const ComputationStep(this.word);
}

/// An error caused by the input expression (coming from the user)
class ComputationError extends Error {
  /// The step where the error occurred.
  final ComputationStep step;

  /// The message of the error.
  final String message;

  /// Where the error happened.
  final int? globalPosition;

  /// Creates the error.
  ComputationError(this.step, {required this.message, this.globalPosition});

  @override
  String toString() {
    return "An error was caught while ${step.word}${globalPosition == null ? "" : " at $globalPosition"}: $message";
  }
}
