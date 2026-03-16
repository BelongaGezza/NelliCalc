import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nelli_calc/engine/calculator_engine.dart';
import 'package:nelli_calc/engine/calculator_error.dart';
import 'package:nelli_calc/models/calculator_state.dart';

/// Formats a [double] result for display on the calculator screen.
///
/// Strips trailing zeros, caps at 10 significant digits, and corrects
/// common floating-point artefacts (e.g., `0.1 + 0.2` displays as `"0.3"`).
///
/// Example:
/// ```dart
/// formatResult(4.0);   // "4"
/// formatResult(0.3);   // "0.3"
/// formatResult(-15.0); // "-15"
/// ```
String formatResult(double value) {
  final rounded = double.parse(value.toStringAsPrecision(10));
  var text = rounded.toString();

  if (text.contains('.')) {
    text = text.replaceAll(RegExp(r'0+$'), '');
    text = text.replaceAll(RegExp(r'\.$'), '');
  }

  return text;
}

/// Manages the current calculator state (expression, result, error).
///
/// Delegates evaluation to [CalculatorEngine] and updates [CalculatorState]
/// immutably on each action.
class CalculatorNotifier extends StateNotifier<CalculatorState> {
  /// Creates a [CalculatorNotifier].
  ///
  /// The [engine] is injected for testability. If not provided, a default
  /// [CalculatorEngine] is used.
  CalculatorNotifier({CalculatorEngine? engine})
    : _engine = engine ?? CalculatorEngine(),
      super(const CalculatorState());

  final CalculatorEngine _engine;

  /// Appends a digit character ('0'-'9') to the current expression.
  void inputDigit(String digit) {
    final expr = '${state.expression}$digit';
    state = state.copyWith(
      expression: expr,
      display: state.expression.isEmpty ? digit : expr,
      error: () => null,
    );
  }

  /// Appends an operator ('+', '-', '*', '/') to the current expression.
  void inputOperator(String operator) {
    final expr = state.expression + operator;
    state = state.copyWith(
      expression: expr,
      display: expr,
      error: () => null,
    );
  }

  /// Appends a decimal point to the current expression.
  void inputDecimal() {
    final expr = '${state.expression}.';
    state = state.copyWith(
      expression: expr,
      display: state.expression.isEmpty ? '0.' : expr,
      error: () => null,
    );
  }

  /// Appends an opening or closing parenthesis to the expression.
  void inputParenthesis(String paren) {
    final expr = '${state.expression}$paren';
    state = state.copyWith(
      expression: expr,
      display: expr,
      error: () => null,
    );
  }

  /// Inserts a value from a dragged history item into the expression.
  void insertValue(String value) {
    final expr = '${state.expression}$value';
    state = state.copyWith(
      expression: expr,
      display: expr,
      error: () => null,
    );
  }

  /// Delegates the current expression to [CalculatorEngine.evaluate],
  /// and updates state with the result or error.
  void evaluate() {
    final expr = state.expression.trim();
    if (expr.isEmpty) {
      return;
    }

    try {
      final result = _engine.evaluate(expr);
      state = state.copyWith(
        display: formatResult(result),
        result: () => result,
        error: () => null,
      );
    } on CalculatorError catch (e) {
      state = state.copyWith(
        result: () => null,
        error: () => e,
      );
    }
  }

  /// Resets the expression, display, result, and error to defaults.
  void clear() {
    state = const CalculatorState();
  }

  /// Removes the last character from the current expression.
  void backspace() {
    if (state.expression.isEmpty) {
      return;
    }
    final newExpression = state.expression.substring(
      0,
      state.expression.length - 1,
    );
    state = state.copyWith(
      expression: newExpression,
      display: newExpression.isEmpty ? '0' : newExpression,
      error: () => null,
    );
  }
}

/// Provides the calculator state and notifier.
///
/// The notifier delegates evaluation to [CalculatorEngine] and manages
/// all input methods (digits, operators, decimal, parentheses, etc.).
final calculatorProvider =
    StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
      return CalculatorNotifier();
    });
