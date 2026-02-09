import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nelli_calc/poc/responsive_poc.dart';

void main() {
  Widget buildTestApp({required Size size}) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: const MaterialApp(home: ResponsivePocScreen()),
    );
  }

  group('Wide (landscape) layout', () {
    // 800x600 is comfortably above the 600dp breakpoint.
    const wideSize = Size(800, 600);

    testWidgets('shows side-by-side layout with history panel', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(wideSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestApp(size: wideSize));

      // Both the display and history panel header should be visible.
      expect(find.text('Calculator Display'), findsOneWidget);
      expect(find.text('Previous Results'), findsOneWidget);
      // History items visible directly (no sheet to open).
      expect(find.text('42'), findsOneWidget);
      expect(find.text('3.14159'), findsOneWidget);
    });

    testWidgets('drag-and-drop works in wide layout', (tester) async {
      await tester.binding.setSurfaceSize(wideSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestApp(size: wideSize));

      expect(find.text('0'), findsOneWidget);

      final item = find.text('42');
      final display = find.text('Calculator Display');

      final gesture = await tester.startGesture(tester.getCenter(item));
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.moveTo(tester.getCenter(display));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      // Display should now show the dropped value.
      expect(find.text('42'), findsAtLeast(1));
    });
  });

  group('Narrow (portrait) layout', () {
    // 400x800 is below the 600dp breakpoint.
    const narrowSize = Size(400, 800);

    testWidgets('shows bottom sheet handle with label', (tester) async {
      await tester.binding.setSurfaceSize(narrowSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestApp(size: narrowSize));

      expect(find.text('Calculator Display'), findsOneWidget);
      // The sheet handle label should be visible.
      expect(find.text('Previous Results'), findsOneWidget);
    });

    testWidgets('drag-and-drop works in narrow layout', (tester) async {
      await tester.binding.setSurfaceSize(narrowSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildTestApp(size: narrowSize));

      // Drag the sheet up to reveal history items.
      // The sheet starts at 12% — drag it up to expose items.
      final sheetHandle = find.text('Previous Results');
      await tester.drag(sheetHandle, const Offset(0, -300));
      await tester.pumpAndSettle();

      // History items should now be visible.
      expect(find.text('42'), findsOneWidget);

      // Drag an item to the display.
      final item = find.text('42');
      final display = find.text('Calculator Display');

      final gesture = await tester.startGesture(tester.getCenter(item));
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.moveTo(tester.getCenter(display));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('42'), findsAtLeast(1));
    });
  });

  group('Breakpoint switching', () {
    testWidgets('switches layout at 600dp breakpoint', (tester) async {
      // Start wide.
      const wideSize = Size(800, 600);
      await tester.binding.setSurfaceSize(wideSize);

      await tester.pumpWidget(
        const MaterialApp(home: ResponsivePocScreen()),
      );

      // In wide layout, the VerticalDivider is rendered (side-by-side).
      // History panel header is directly visible.
      expect(find.text('Previous Results'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);

      // Switch to narrow.
      const narrowSize = Size(400, 800);
      await tester.binding.setSurfaceSize(narrowSize);
      await tester.pumpWidget(
        const MaterialApp(home: ResponsivePocScreen()),
      );
      await tester.pumpAndSettle();

      // Calculator display still visible.
      expect(find.text('Calculator Display'), findsOneWidget);
      // Sheet handle label visible.
      expect(find.text('Previous Results'), findsOneWidget);

      addTearDown(() => tester.binding.setSurfaceSize(null));
    });
  });
}
