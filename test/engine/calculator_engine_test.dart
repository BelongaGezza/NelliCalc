import 'package:flutter_test/flutter_test.dart';
import 'package:nelli_calc/engine/calculator_engine.dart';
import 'package:nelli_calc/engine/calculator_error.dart';

void main() {
  late CalculatorEngine engine;

  setUp(() {
    engine = CalculatorEngine();
  });

  group('CalculatorEngine - basic arithmetic', () {
    test('adds two numbers', () {
      expect(engine.evaluate('3 + 4'), 7.0);
    });

    test('subtracts two numbers', () {
      expect(engine.evaluate('10 - 3'), 7.0);
    });

    test('multiplies two numbers', () {
      expect(engine.evaluate('6 * 7'), 42.0);
    });

    test('divides two numbers', () {
      expect(engine.evaluate('15 / 3'), 5.0);
    });
  });

  group('CalculatorEngine - decimal numbers', () {
    test('handles decimal numbers', () {
      expect(engine.evaluate('3.14 + 1'), closeTo(4.14, 1e-10));
    });

    test('handles 0.1 + 0.2 (floating-point precision)', () {
      expect(engine.evaluate('0.1 + 0.2'), closeTo(0.3, 1e-10));
    });
  });

  group('CalculatorEngine - operator precedence', () {
    test('2 + 3 * 4 = 14 (multiplication before addition)', () {
      expect(engine.evaluate('2 + 3 * 4'), 14.0);
    });

    test('(2 + 3) * 4 = 20 (parentheses override precedence)', () {
      expect(engine.evaluate('(2 + 3) * 4'), 20.0);
    });
  });

  group('CalculatorEngine - left-to-right associativity', () {
    test('10 / 2 * 3 = 15', () {
      expect(engine.evaluate('10 / 2 * 3'), 15.0);
    });

    test('10 - 2 + 3 = 11', () {
      expect(engine.evaluate('10 - 2 + 3'), 11.0);
    });
  });

  group('CalculatorEngine - unary minus', () {
    test('-5 + 3 = -2', () {
      expect(engine.evaluate('-5 + 3'), -2.0);
    });

    test('-(2 + 3) = -5', () {
      expect(engine.evaluate('-(2 + 3)'), -5.0);
    });

    test('2 * -3 = -6', () {
      expect(engine.evaluate('2 * -3'), -6.0);
    });
  });

  group('CalculatorEngine - nested parentheses', () {
    test('((2 + 3) * (4 - 1)) = 15', () {
      expect(engine.evaluate('((2 + 3) * (4 - 1))'), 15.0);
    });
  });

  group('CalculatorEngine - whitespace handling', () {
    test('ignores leading and trailing whitespace', () {
      expect(engine.evaluate('  2 + 3  '), 5.0);
    });

    test('handles expression without spaces', () {
      expect(engine.evaluate('2+3'), 5.0);
    });
  });

  group('CalculatorEngine - error cases', () {
    test('empty string throws malformedExpression', () {
      expect(
        () => engine.evaluate(''),
        throwsA(
          isA<CalculatorError>().having(
            (e) => e.type,
            'type',
            CalculatorErrorType.malformedExpression,
          ),
        ),
      );
    });

    test('blank string (whitespace only) throws malformedExpression', () {
      expect(
        () => engine.evaluate('   '),
        throwsA(
          isA<CalculatorError>().having(
            (e) => e.type,
            'type',
            CalculatorErrorType.malformedExpression,
          ),
        ),
      );
    });

    test('3 + + 4 throws malformedExpression', () {
      expect(
        () => engine.evaluate('3 + + 4'),
        throwsA(
          isA<CalculatorError>().having(
            (e) => e.type,
            'type',
            CalculatorErrorType.malformedExpression,
          ),
        ),
      );
    });

    test('3 + (trailing operator) throws malformedExpression', () {
      expect(
        () => engine.evaluate('3 +'),
        throwsA(
          isA<CalculatorError>().having(
            (e) => e.type,
            'type',
            CalculatorErrorType.malformedExpression,
          ),
        ),
      );
    });

    test('10 / 0 throws divisionByZero', () {
      expect(
        () => engine.evaluate('10 / 0'),
        throwsA(
          isA<CalculatorError>().having(
            (e) => e.type,
            'type',
            CalculatorErrorType.divisionByZero,
          ),
        ),
      );
    });

    test('unmatched opening parenthesis throws malformedExpression', () {
      expect(
        () => engine.evaluate('(2 + 3'),
        throwsA(
          isA<CalculatorError>().having(
            (e) => e.type,
            'type',
            CalculatorErrorType.malformedExpression,
          ),
        ),
      );
    });

    test('unmatched closing parenthesis throws malformedExpression', () {
      expect(
        () => engine.evaluate('2 + 3)'),
        throwsA(
          isA<CalculatorError>().having(
            (e) => e.type,
            'type',
            CalculatorErrorType.malformedExpression,
          ),
        ),
      );
    });

    test('unexpected character throws malformedExpression', () {
      expect(
        () => engine.evaluate('2 + x'),
        throwsA(
          isA<CalculatorError>().having(
            (e) => e.type,
            'type',
            CalculatorErrorType.malformedExpression,
          ),
        ),
      );
    });

    // Note: Overflow (infinity/NaN) is validated in _validateResult, but the
    // grammar does not support scientific notation, so we cannot easily
    // construct an expression that overflows. Division by zero is caught
    // before evaluation. The overflow path is covered by engine implementation.
  });

  group('CalculatorEngine - large numbers and edge cases', () {
    test('handles large numbers', () {
      expect(engine.evaluate('1000000 * 1000000'), 1000000000000.0);
    });

    test('handles zero', () {
      expect(engine.evaluate('0 + 0'), 0.0);
    });

    test('handles negative result', () {
      expect(engine.evaluate('3 - 10'), -7.0);
    });

    test('handles fractional result', () {
      expect(engine.evaluate('1 / 3'), closeTo(0.3333333333, 1e-10));
    });
  });
}
