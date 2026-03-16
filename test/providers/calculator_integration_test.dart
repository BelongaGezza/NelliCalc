import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nelli_calc/models/calculator_state.dart';
import 'package:nelli_calc/providers/calculator_provider.dart';

void main() {
  group('CalculatorProvider integration', () {
    test('initial state is default CalculatorState', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(calculatorProvider);

      expect(state, const CalculatorState());
      expect(state.expression, '');
      expect(state.display, '0');
      expect(state.result, isNull);
      expect(state.error, isNull);
    });

    test('full calculation via notifier produces correct result', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(calculatorProvider.notifier)
        ..inputDigit('2')
        ..inputOperator('+')
        ..inputDigit('3')
        ..evaluate();

      final state = container.read(calculatorProvider);

      expect(state.result, 5.0);
      expect(state.display, '5');
      expect(state.error, isNull);
    });
  });
}
