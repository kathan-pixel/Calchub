import 'package:flutter/material.dart';

enum CalculatorCategory {
  financial,
  health,
  utility,
}

class Calculator {
  final String id;
  final String name;
  final String description;
  final CalculatorCategory category;
  final IconData icon;
  final Widget Function(BuildContext) builder;

  Calculator({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.builder,
  });
}
