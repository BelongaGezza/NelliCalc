import 'package:flutter_test/flutter_test.dart';

import 'package:nelli_calc/main.dart';

void main() {
  testWidgets('NelliCalc app renders responsive PoC', (tester) async {
    await tester.pumpWidget(const NelliCalcApp());

    expect(find.text('Responsive PoC'), findsOneWidget);
    expect(find.text('Calculator Display'), findsOneWidget);
  });
}
