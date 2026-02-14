import 'package:equatable/equatable.dart';

import 'package:nelli_calc/engine/calculator_error.dart';

/// The complete state of the calculator at a point in time.
///
/// This class is immutable. Use [copyWith] to produce a new state
/// with one or more fields changed.
///
/// Example:
/// ```dart
/// const state = CalculatorState();
/// final updated = state.copyWith(expression: '12 + 3');
/// ```
class CalculatorState extends Equatable {
  /// Creates a [CalculatorState].
  const CalculatorState({
    this.expression = '',
    this.display = '0',
    this.result,
    this.error,
  });

  /// The mathematical expression being built (e.g., `'12 + 3.14'`).
  ///
  /// Empty string when the calculator is freshly cleared.
  final String expression;

  /// The text currently shown on the calculator display.
  ///
  /// Defaults to `'0'`. Updated as the user types digits/operators,
  /// and replaced with the formatted result after evaluation.
  final String display;

  /// The evaluated result, or `null` if the expression has not been
  /// evaluated or the last evaluation produced an error.
  final double? result;

  /// The error from the last evaluation attempt, or `null` if the
  /// last evaluation succeeded (or no evaluation has occurred).
  final CalculatorError? error;

  /// Returns `true` when the calculator is in an error state.
  bool get hasError => error != null;

  /// Returns `true` when a successful result is available.
  bool get hasResult => result != null && !hasError;

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// The [result] and [error] parameters use a nullable factory
  /// (`T? Function()?`) so callers can explicitly set them to `null`
  /// (e.g., `copyWith(error: () => null)` to clear an error).
  CalculatorState copyWith({
    String? expression,
    String? display,
    double? Function()? result,
    CalculatorError? Function()? error,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      display: display ?? this.display,
      result: result != null ? result() : this.result,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [expression, display, result, error];
}
