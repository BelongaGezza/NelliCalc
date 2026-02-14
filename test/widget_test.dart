import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nelli_calc/app.dart';

void main() {
  testWidgets('NelliCalc app renders placeholder home screen', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: NelliCalcApp()));

    expect(find.text('NelliCalc'), findsOneWidget);
    expect(find.text('NelliCalc — Coming soon'), findsOneWidget);
  });
}
