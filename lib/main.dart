import 'package:flutter/material.dart';
import 'package:nelli_calc/poc/responsive_poc.dart';

void main() {
  runApp(const NelliCalcApp());
}

class NelliCalcApp extends StatelessWidget {
  const NelliCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NelliCalc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ResponsivePocScreen(),
    );
  }
}
