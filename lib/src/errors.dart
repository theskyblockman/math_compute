enum ComputationStep {
  lexing("lexing"),
  parsing("parsing"),
  eval("evaluating");

  final String word;

  const ComputationStep(this.word);
}

class ComputationError extends Error {
  final ComputationStep step;
  final String message;
  final int? globalPosition;

  ComputationError(this.step, {required this.message, this.globalPosition});

  @override
  String toString() {
    return "An error was caught while ${step.word}${globalPosition == null ? "" : " at $globalPosition"}: $message";
  }
}
