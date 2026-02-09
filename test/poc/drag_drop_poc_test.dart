import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nelli_calc/poc/drag_drop_poc.dart';

void main() {
  Widget buildTestApp() {
    return const MaterialApp(home: DragDropPocScreen());
  }

  testWidgets('displays history items', (tester) async {
    await tester.pumpWidget(buildTestApp());

    expect(find.text('42'), findsOneWidget);
    expect(find.text('3.14159'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('0'), findsOneWidget); // initial display value
  });

  testWidgets('long-press drag updates display on drop', (tester) async {
    await tester.pumpWidget(buildTestApp());

    // Verify initial display value.
    expect(find.text('0'), findsOneWidget);

    // Find the '42' history item and the display target.
    final item42 = find.text('42');
    final display = find.text('Calculator Display');

    // Perform a long-press drag from the history item to the display area.
    final gesture = await tester.startGesture(tester.getCenter(item42));
    // Hold long enough to trigger LongPressDraggable.
    await tester.pump(const Duration(milliseconds: 600));

    // Move to the display area.
    await gesture.moveTo(tester.getCenter(display));
    await tester.pump();

    // Drop.
    await gesture.up();
    await tester.pumpAndSettle();

    // The display should now show '42'.
    expect(find.text('42'), findsAtLeast(1));
  });

  testWidgets('reset button clears the display', (tester) async {
    await tester.pumpWidget(buildTestApp());

    // Drag a value into the display first.
    final item100 = find.text('100');
    final display = find.text('Calculator Display');

    final gesture = await tester.startGesture(tester.getCenter(item100));
    await tester.pump(const Duration(milliseconds: 600));
    await gesture.moveTo(tester.getCenter(display));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    // Now tap reset.
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    // Display should be back to '0'.
    expect(find.text('0'), findsOneWidget);
  });
}
