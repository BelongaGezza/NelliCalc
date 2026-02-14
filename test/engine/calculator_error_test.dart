import 'package:flutter_test/flutter_test.dart';
import 'package:nelli_calc/engine/calculator_error.dart';

void main() {
  group('CalculatorError', () {
    test('constructs with required fields', () {
      const error = CalculatorError(
        type: CalculatorErrorType.divisionByZero,
        message: 'Cannot divide by zero',
      );

      expect(error.type, CalculatorErrorType.divisionByZero);
      expect(error.message, 'Cannot divide by zero');
    });

    test('implements Exception', () {
      const error = CalculatorError(
        type: CalculatorErrorType.overflow,
        message: 'Result is too large',
      );

      expect(error, isA<Exception>());
    });

    test('toString includes type and message', () {
      const error = CalculatorError(
        type: CalculatorErrorType.malformedExpression,
        message: 'Invalid expression',
      );

      expect(
        error.toString(),
        'CalculatorError(CalculatorErrorType.malformedExpression): '
        'Invalid expression',
      );
    });

    group('equality', () {
      test('equal when type and message match', () {
        const a = CalculatorError(
          type: CalculatorErrorType.divisionByZero,
          message: 'Cannot divide by zero',
        );
        const b = CalculatorError(
          type: CalculatorErrorType.divisionByZero,
          message: 'Cannot divide by zero',
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('not equal when type differs', () {
        const a = CalculatorError(
          type: CalculatorErrorType.divisionByZero,
          message: 'Error',
        );
        const b = CalculatorError(
          type: CalculatorErrorType.overflow,
          message: 'Error',
        );

        expect(a, isNot(equals(b)));
      });

      test('not equal when message differs', () {
        const a = CalculatorError(
          type: CalculatorErrorType.divisionByZero,
          message: 'Error A',
        );
        const b = CalculatorError(
          type: CalculatorErrorType.divisionByZero,
          message: 'Error B',
        );

        expect(a, isNot(equals(b)));
      });
    });
  });

  group('CalculatorErrorType', () {
    test('has all expected values', () {
      expect(CalculatorErrorType.values, hasLength(4));
      expect(
        CalculatorErrorType.values,
        containsAll([
          CalculatorErrorType.divisionByZero,
          CalculatorErrorType.malformedExpression,
          CalculatorErrorType.overflow,
          CalculatorErrorType.unknownError,
        ]),
      );
    });
  });
}
