import 'package:flutter_test/flutter_test.dart';
import 'package:nelli_calc/engine/calculator_error.dart';
import 'package:nelli_calc/models/calculator_state.dart';

void main() {
  group('CalculatorState', () {
    test('has sensible defaults', () {
      const state = CalculatorState();

      expect(state.expression, '');
      expect(state.display, '0');
      expect(state.result, isNull);
      expect(state.error, isNull);
    });

    test('constructs with all fields', () {
      const error = CalculatorError(
        type: CalculatorErrorType.divisionByZero,
        message: 'Cannot divide by zero',
      );
      const state = CalculatorState(
        expression: '10 / 0',
        display: 'Error',
        error: error,
      );

      expect(state.expression, '10 / 0');
      expect(state.display, 'Error');
      expect(state.result, isNull);
      expect(state.error, error);
    });

    group('hasError', () {
      test('returns false when error is null', () {
        const state = CalculatorState();
        expect(state.hasError, isFalse);
      });

      test('returns true when error is set', () {
        const state = CalculatorState(
          error: CalculatorError(
            type: CalculatorErrorType.divisionByZero,
            message: 'Cannot divide by zero',
          ),
        );
        expect(state.hasError, isTrue);
      });
    });

    group('hasResult', () {
      test('returns false when result is null', () {
        const state = CalculatorState();
        expect(state.hasResult, isFalse);
      });

      test('returns true when result is set and no error', () {
        const state = CalculatorState(result: 42);
        expect(state.hasResult, isTrue);
      });

      test('returns false when result is set but error exists', () {
        const state = CalculatorState(
          result: 42,
          error: CalculatorError(
            type: CalculatorErrorType.unknownError,
            message: 'Something went wrong',
          ),
        );
        expect(state.hasResult, isFalse);
      });
    });

    group('copyWith', () {
      test('copies with no changes when called with no arguments', () {
        const original = CalculatorState(
          expression: '2 + 3',
          display: '5',
          result: 5,
        );
        final copy = original.copyWith();

        expect(copy, equals(original));
      });

      test('copies with expression changed', () {
        const original = CalculatorState();
        final copy = original.copyWith(expression: '12 + 3');

        expect(copy.expression, '12 + 3');
        expect(copy.display, original.display);
      });

      test('copies with display changed', () {
        const original = CalculatorState();
        final copy = original.copyWith(display: '42');

        expect(copy.display, '42');
        expect(copy.expression, original.expression);
      });

      test('copies with result set', () {
        const original = CalculatorState();
        final copy = original.copyWith(result: () => 42);

        expect(copy.result, 42);
      });

      test('copies with result cleared to null', () {
        const original = CalculatorState(result: 42);
        final copy = original.copyWith(result: () => null);

        expect(copy.result, isNull);
      });

      test('copies with error set', () {
        const error = CalculatorError(
          type: CalculatorErrorType.divisionByZero,
          message: 'Cannot divide by zero',
        );
        const original = CalculatorState();
        final copy = original.copyWith(error: () => error);

        expect(copy.error, error);
      });

      test('copies with error cleared to null', () {
        const original = CalculatorState(
          error: CalculatorError(
            type: CalculatorErrorType.divisionByZero,
            message: 'Cannot divide by zero',
          ),
        );
        final copy = original.copyWith(error: () => null);

        expect(copy.error, isNull);
      });
    });

    group('equality', () {
      test('equal when all fields match', () {
        const a = CalculatorState(
          expression: '2 + 3',
          display: '5',
          result: 5,
        );
        const b = CalculatorState(
          expression: '2 + 3',
          display: '5',
          result: 5,
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('not equal when expression differs', () {
        const a = CalculatorState(expression: '2 + 3');
        const b = CalculatorState(expression: '3 + 2');

        expect(a, isNot(equals(b)));
      });

      test('not equal when display differs', () {
        const a = CalculatorState(display: '5');
        const b = CalculatorState(display: '6');

        expect(a, isNot(equals(b)));
      });

      test('not equal when result differs', () {
        const a = CalculatorState(result: 5);
        const b = CalculatorState(result: 6);

        expect(a, isNot(equals(b)));
      });

      test('not equal when error differs', () {
        const a = CalculatorState(
          error: CalculatorError(
            type: CalculatorErrorType.divisionByZero,
            message: 'Cannot divide by zero',
          ),
        );
        const b = CalculatorState();

        expect(a, isNot(equals(b)));
      });
    });
  });
}
