import 'package:flutter/material.dart';
import 'package:nelli_calc/layout/responsive_shell.dart';

/// The root widget for the NelliCalc application.
class NelliCalcApp extends StatelessWidget {
  /// Creates a [NelliCalcApp].
  const NelliCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NelliCalc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ResponsiveShell(),
    );
  }
}
