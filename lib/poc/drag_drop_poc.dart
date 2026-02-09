import 'package:flutter/material.dart';

/// Proof-of-concept screen demonstrating drag-and-drop of previous results
/// into a calculator display area.
///
/// This is throwaway code to validate the interaction model.
/// It will be removed once the PoC findings are documented.
class DragDropPocScreen extends StatefulWidget {
  const DragDropPocScreen({super.key});

  @override
  State<DragDropPocScreen> createState() => _DragDropPocScreenState();
}

class _DragDropPocScreenState extends State<DragDropPocScreen> {
  /// Mock history of previous calculation results.
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

  /// Current value shown in the calculator display.
  String _displayValue = '0';

  /// Whether a draggable is currently hovering over the display target.
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Drag & Drop PoC'),
      ),
      body: Column(
        children: [
          _buildCalculatorDisplay(),
          const Divider(height: 1),
          Expanded(child: _buildHistoryList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetDisplay,
        tooltip: 'Reset',
        child: const Icon(Icons.refresh),
      ),
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

  Widget _buildHistoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Previous Results (long-press to drag)',
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
