import 'package:equatable/equatable.dart';

/// Categories of calculator evaluation failures.
enum CalculatorErrorType {
  /// Division by zero (e.g., `10 / 0`).
  divisionByZero,

  /// The expression could not be parsed (e.g., `3 + + 4`).
  malformedExpression,

  /// The result exceeds the representable range.
  overflow,

  /// An unexpected error occurred during evaluation.
  unknownError,
}

/// Represents an error produced by the calculator engine.
///
/// Errors are stored as data in `CalculatorState`, not thrown to the UI.
///
/// Example:
/// ```dart
/// const error = CalculatorError(
///   type: CalculatorErrorType.divisionByZero,
///   message: 'Cannot divide by zero',
/// );
/// ```
class CalculatorError extends Equatable implements Exception {
  /// Creates a [CalculatorError].
  const CalculatorError({
    required this.type,
    required this.message,
  });

  /// The category of the error.
  final CalculatorErrorType type;

  /// A human-readable description of what went wrong.
  final String message;

  @override
  List<Object?> get props => [type, message];

  @override
  String toString() => 'CalculatorError($type): $message';
}
