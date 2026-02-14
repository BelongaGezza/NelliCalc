// TODO(sprint-003): Implement full responsive shell with LayoutBuilder.
//
// Switches between wide (side-by-side history panel) and narrow
// (bottom sheet history) layouts at the 600dp breakpoint.

import 'package:flutter/material.dart';

/// Top-level responsive layout shell.
///
/// Uses [LayoutBuilder] to switch between wide and narrow layouts
/// at the 600dp breakpoint.
class ResponsiveShell extends StatelessWidget {
  /// Creates a [ResponsiveShell].
  const ResponsiveShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NelliCalc'),
      ),
      body: const Center(
        child: Text('NelliCalc — Coming soon'),
      ),
    );
  }
}
