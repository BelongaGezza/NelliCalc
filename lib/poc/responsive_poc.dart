import 'package:flutter/material.dart';

/// Width breakpoint: above this value the app uses landscape (side-by-side)
/// layout; below it uses portrait (slide-over pane) layout.
///
/// 600dp aligns with Material Design's compact/medium breakpoint and covers
/// most phones in portrait (compact) vs landscape or tablets (medium+).
const double kWideLayoutBreakpoint = 600;

/// Proof-of-concept screen demonstrating responsive layouts with
/// drag-and-drop working in both orientations.
///
/// - **Wide (landscape):** Calculator display and history panel side by side.
/// - **Narrow (portrait):** Calculator display full-width; history accessible
///   via a bottom sheet pulled up from the bottom edge.
class ResponsivePocScreen extends StatefulWidget {
  const ResponsivePocScreen({super.key});

  @override
  State<ResponsivePocScreen> createState() => _ResponsivePocScreenState();
}

class _ResponsivePocScreenState extends State<ResponsivePocScreen> {
  final List<String> _history = [
    '42',
    '3.14159',
    '100',
    '7.5',
    '256',
    '0.001',
    '99.99',
    '1024',
  ];

  String _displayValue = '0';
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Responsive PoC'),
        actions: [
          IconButton(
            onPressed: _resetDisplay,
            tooltip: 'Reset',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= kWideLayoutBreakpoint;
          return isWide ? _buildWideLayout() : _buildNarrowLayout();
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Wide (landscape) layout: side-by-side
  // ---------------------------------------------------------------------------

  Widget _buildWideLayout() {
    return Row(
      children: [
        // Calculator display takes 60% of width.
        Expanded(
          flex: 3,
          child: Center(child: _buildCalculatorDisplay()),
        ),
        const VerticalDivider(width: 1),
        // History panel takes 40% of width.
        Expanded(
          flex: 2,
          child: _buildHistoryPanel(),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Narrow (portrait) layout: full-width display + bottom sheet for history
  // ---------------------------------------------------------------------------

  Widget _buildNarrowLayout() {
    return Stack(
      children: [
        // Calculator display fills the screen behind the sheet.
        Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Center(child: _buildCalculatorDisplay()),
        ),
        // Draggable bottom sheet for history.
        _buildHistoryBottomSheet(),
      ],
    );
  }

  Widget _buildHistoryBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.65,
      snap: true,
      snapSizes: const [0.12, 0.4, 0.65],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle.
              _buildSheetHandle(context),
              // History list.
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return _buildDraggableHistoryItem(_history[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetHandle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Previous Results',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared components
  // ---------------------------------------------------------------------------

  Widget _buildHistoryPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Previous Results',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _history.length,
            itemBuilder: (context, index) {
              return _buildDraggableHistoryItem(_history[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatorDisplay() {
    return DragTarget<String>(
      onWillAcceptWithDetails: (_) {
        setState(() => _isHovering = true);
        return true;
      },
      onLeave: (_) {
        setState(() => _isHovering = false);
      },
      onAcceptWithDetails: (details) {
        setState(() {
          _displayValue = details.data;
          _isHovering = false;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isHovering
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovering
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              width: _isHovering ? 3 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _isHovering ? 'Drop here!' : 'Calculator Display',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _displayValue,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggableHistoryItem(String value) {
    final chip = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.drag_indicator,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );

    return LongPressDraggable<String>(
      data: value,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: chip,
      ),
      child: chip,
    );
  }

  void _resetDisplay() {
    setState(() {
      _displayValue = '0';
    });
  }
}
