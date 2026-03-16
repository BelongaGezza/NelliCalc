import 'package:flutter_test/flutter_test.dart';
import 'package:nelli_calc/engine/calculator_engine.dart';
import 'package:nelli_calc/engine/calculator_error.dart';
import 'package:nelli_calc/models/calculator_state.dart';
import 'package:nelli_calc/providers/calculator_provider.dart';

void main() {
  group('CalculatorNotifier - input methods', () {
    test('inputDigit appends to expression', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine());
      expect(notifier.state.expression, '');
      expect(notifier.state.display, '0');

      notifier.inputDigit('5');
      expect(notifier.state.expression, '5');
      expect(notifier.state.display, '5');

      notifier.inputDigit('3');
      expect(notifier.state.expression, '53');
      expect(notifier.state.display, '53');
    });

    test('inputOperator appends to expression', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..inputDigit('2')
        ..inputOperator('+');
      expect(notifier.state.expression, '2+');
      expect(notifier.state.display, '2+');

      notifier.inputDigit('3');
      expect(notifier.state.expression, '2+3');
    });

    test('inputDecimal appends to expression', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..inputDigit('3')
        ..inputDecimal();
      expect(notifier.state.expression, '3.');
      expect(notifier.state.display, '3.');

      notifier
        ..inputDigit('1')
        ..inputDigit('4');
      expect(notifier.state.expression, '3.14');
    });

    test('inputDecimal on empty expression shows 0.', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..inputDecimal();
      expect(notifier.state.expression, '.');
      expect(notifier.state.display, '0.');
    });

    test('inputParenthesis appends to expression', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..inputParenthesis('(')
        ..inputDigit('2')
        ..inputOperator('+')
        ..inputDigit('3')
        ..inputParenthesis(')');
      expect(notifier.state.expression, '(2+3)');
      expect(notifier.state.display, '(2+3)');
    });
  });

  group('CalculatorNotifier - evaluate', () {
    test('evaluate produces correct result and display', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..inputDigit('2')
        ..inputOperator('+')
        ..inputDigit('3')
        ..evaluate();

      expect(notifier.state.result, 5);
      expect(notifier.state.display, '5');
      expect(notifier.state.error, isNull);
    });

    test('evaluate with error sets state.error and clears state.result', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..inputDigit('1')
        ..inputDigit('0')
        ..inputOperator('/')
        ..inputDigit('0')
        ..evaluate();

      expect(notifier.state.result, isNull);
      expect(notifier.state.error, isNotNull);
      expect(notifier.state.error!.type, CalculatorErrorType.divisionByZero);
    });

    test('evaluate on empty expression returns early without change', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..evaluate();
      expect(notifier.state, const CalculatorState());
    });

    test('evaluate clears previous error on success', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..inputDigit('1')
        ..inputOperator('/')
        ..inputDigit('0')
        ..evaluate();
      expect(notifier.state.error, isNotNull);

      notifier
        ..clear()
        ..inputDigit('2')
        ..inputOperator('+')
        ..inputDigit('3')
        ..evaluate();
      expect(notifier.state.error, isNull);
      expect(notifier.state.result, 5);
    });
  });

  group('CalculatorNotifier - clear', () {
    test('clear resets to default state', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..inputDigit('5')
        ..inputOperator('+')
        ..inputDigit('3')
        ..evaluate()
        ..clear();

      expect(notifier.state.expression, '');
      expect(notifier.state.display, '0');
      expect(notifier.state.result, isNull);
      expect(notifier.state.error, isNull);
    });
  });

  group('CalculatorNotifier - backspace', () {
    test('backspace removes last character', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..inputDigit('5')
        ..inputDigit('3');
      expect(notifier.state.expression, '53');

      notifier.backspace();
      expect(notifier.state.expression, '5');
      expect(notifier.state.display, '5');

      notifier.backspace();
      expect(notifier.state.expression, '');
      expect(notifier.state.display, '0');
    });

    test('backspace on empty expression keeps display as 0', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine());
      expect(notifier.state.expression, '');
      expect(notifier.state.display, '0');

      notifier.backspace();
      expect(notifier.state.expression, '');
      expect(notifier.state.display, '0');
    });
  });

  group('CalculatorNotifier - insertValue', () {
    test('insertValue appends to expression', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..inputDigit('1')
        ..inputOperator('+')
        ..insertValue('42');
      expect(notifier.state.expression, '1+42');
      expect(notifier.state.display, '1+42');
    });

    test('insertValue on empty expression works', () {
      final notifier = CalculatorNotifier(engine: CalculatorEngine())
        ..insertValue('3.14');
      expect(notifier.state.expression, '3.14');
      expect(notifier.state.display, '3.14');
    });
  });

  group('formatResult', () {
    test('strips trailing zeros from integer results', () {
      expect(formatResult(4), '4');
      expect(formatResult(15), '15');
    });

    test('strips trailing zeros from decimal results', () {
      expect(formatResult(3.10), '3.1');
    });

    test('handles negative results', () {
      expect(formatResult(-15), '-15');
      expect(formatResult(-3.14), '-3.14');
    });

    test('corrects floating-point artefacts (0.1 + 0.2)', () {
      expect(formatResult(0.1 + 0.2), '0.3');
    });

    test('caps at 10 significant digits', () {
      const value = 1234567890.123456789;
      expect(formatResult(value).length, lessThanOrEqualTo(12));
    });
  });
}
