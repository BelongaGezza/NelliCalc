import 'package:nelli_calc/engine/calculator_error.dart';

/// Evaluates arithmetic expressions.
///
/// The engine is a pure Dart class with no Flutter dependency.
/// It receives an expression string built by the calculator notifier
/// as the user taps buttons, and returns a numeric result.
///
/// All failure modes throw [CalculatorError] with a typed reason.
///
/// Example:
/// ```dart
/// final engine = CalculatorEngine();
/// final result = engine.evaluate('(2 + 3) * 4'); // 20.0
/// ```
class CalculatorEngine {
  /// Creates a [CalculatorEngine].
  CalculatorEngine();

  late String _source;
  late int _pos;

  /// Evaluates the given mathematical [expression] and returns the
  /// numeric result as a [double].
  ///
  /// Supported tokens: digits (`0`-`9`), decimal point (`.`),
  /// operators (`+`, `-`, `*`, `/`), parentheses (`(`, `)`),
  /// and whitespace (ignored).
  ///
  /// Throws [CalculatorError] if:
  /// - The expression is empty or blank
  /// - The expression is syntactically malformed
  /// - Division by zero is encountered
  /// - The result overflows (infinity or NaN)
  ///
  /// The method is stateless: calling it multiple times with the same
  /// input always produces the same output.
  double evaluate(String expression) {
    try {
      _source = expression.trim();
      _pos = 0;

      if (_source.isEmpty) {
        throw const CalculatorError(
          type: CalculatorErrorType.malformedExpression,
          message: 'Expression is empty.',
        );
      }

      final result = _parseExpression();
      _skipWhitespace();

      if (_pos < _source.length) {
        throw CalculatorError(
          type: CalculatorErrorType.malformedExpression,
          message: 'Unexpected character: "${_source[_pos]}".',
        );
      }

      return _validateResult(result);
    } on CalculatorError {
      rethrow;
    } catch (e) {
      throw CalculatorError(
        type: CalculatorErrorType.unknownError,
        message: 'Calculation error: $e',
      );
    }
  }

  void _skipWhitespace() {
    while (_pos < _source.length && _isWhitespace(_source[_pos])) {
      _pos++;
    }
  }

  bool _isWhitespace(String c) =>
      c == ' ' || c == '\t' || c == '\n' || c == '\r';

  bool _isDigit(String c) =>
      c.length == 1 && c.codeUnitAt(0) >= 0x30 && c.codeUnitAt(0) <= 0x39;

  /// expression ::= term (('+' | '-') term)*
  double _parseExpression() {
    var value = _parseTerm();
    _skipWhitespace();

    while (_pos < _source.length) {
      final op = _source[_pos];
      if (op == '+') {
        _pos++;
        _skipWhitespace();
        value += _parseTerm();
        _skipWhitespace();
      } else if (op == '-') {
        _pos++;
        _skipWhitespace();
        value -= _parseTerm();
        _skipWhitespace();
      } else {
        break;
      }
    }
    return value;
  }

  /// term ::= unary (('*' | '/') unary)*
  double _parseTerm() {
    var value = _parseUnary();
    _skipWhitespace();

    while (_pos < _source.length) {
      final op = _source[_pos];
      if (op == '*') {
        _pos++;
        _skipWhitespace();
        value *= _parseUnary();
        _skipWhitespace();
      } else if (op == '/') {
        _pos++;
        _skipWhitespace();
        final divisor = _parseUnary();
        if (divisor == 0) {
          throw const CalculatorError(
            type: CalculatorErrorType.divisionByZero,
            message: 'Cannot divide by zero.',
          );
        }
        value /= divisor;
        _skipWhitespace();
      } else {
        break;
      }
    }
    return value;
  }

  /// unary ::= '-' unary | primary
  double _parseUnary() {
    _skipWhitespace();
    if (_pos < _source.length && _source[_pos] == '-') {
      _pos++;
      return -_parseUnary();
    }
    return _parsePrimary();
  }

  /// primary ::= NUMBER | '(' expression ')'
  double _parsePrimary() {
    _skipWhitespace();
    if (_pos >= _source.length) {
      throw const CalculatorError(
        type: CalculatorErrorType.malformedExpression,
        message: 'Unexpected end of expression.',
      );
    }

    if (_source[_pos] == '(') {
      _pos++;
      _skipWhitespace();
      final value = _parseExpression();
      _skipWhitespace();
      if (_pos >= _source.length || _source[_pos] != ')') {
        throw const CalculatorError(
          type: CalculatorErrorType.malformedExpression,
          message: 'Unmatched opening parenthesis.',
        );
      }
      _pos++;
      return value;
    }

    return _parseNumber();
  }

  /// NUMBER ::= DIGIT+ ('.' DIGIT+)?
  double _parseNumber() {
    _skipWhitespace();
    if (_pos >= _source.length) {
      throw const CalculatorError(
        type: CalculatorErrorType.malformedExpression,
        message: 'Expected number.',
      );
    }

    final start = _pos;

    if (!_isDigit(_source[_pos])) {
      throw CalculatorError(
        type: CalculatorErrorType.malformedExpression,
        message: 'Unexpected character: "${_source[_pos]}".',
      );
    }

    while (_pos < _source.length && _isDigit(_source[_pos])) {
      _pos++;
    }

    if (_pos < _source.length && _source[_pos] == '.') {
      _pos++;
      if (_pos >= _source.length || !_isDigit(_source[_pos])) {
        throw const CalculatorError(
          type: CalculatorErrorType.malformedExpression,
          message: 'Invalid decimal number.',
        );
      }
      while (_pos < _source.length && _isDigit(_source[_pos])) {
        _pos++;
      }
    }

    final token = _source.substring(start, _pos);
    final value = double.tryParse(token);
    if (value == null) {
      throw CalculatorError(
        type: CalculatorErrorType.malformedExpression,
        message: 'Invalid number: "$token".',
      );
    }
    return value;
  }

  double _validateResult(double value) {
    if (value.isInfinite) {
      throw const CalculatorError(
        type: CalculatorErrorType.overflow,
        message: 'Result is too large.',
      );
    }
    if (value.isNaN) {
      throw const CalculatorError(
        type: CalculatorErrorType.overflow,
        message: 'Result is undefined.',
      );
    }
    return value;
  }
}
