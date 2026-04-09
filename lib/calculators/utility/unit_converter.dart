import 'package:flutter/material.dart';

class UnitConverter extends StatefulWidget {
  const UnitConverter({super.key});

  @override
  State<UnitConverter> createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  final TextEditingController _inputController = TextEditingController();

  String _selectedCategory = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Feet';
  double _result = 0;
  bool _calculated = false;

  final Map<String, Map<String, double>> _conversions = const {
    'Length': {
      'Meters': 1,
      'Feet': 3.28084,
      'Inches': 39.3701,
      'Kilometers': 0.001,
      'Miles': 0.000621371,
      'Centimeters': 100,
    },
    'Weight': {
      'Kilograms': 1,
      'Pounds': 2.20462,
      'Ounces': 35.274,
      'Grams': 1000,
      'Tons': 0.001,
    },
  };

  void _convert() {
    final input = double.tryParse(_inputController.text) ?? 0;
    if (input < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    final fromFactor = _conversions[_selectedCategory]![_fromUnit]!;
    final toFactor = _conversions[_selectedCategory]![_toUnit]!;
    setState(() {
      _result = (input / fromFactor) * toFactor;
      _calculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final units = _conversions[_selectedCategory]!.keys.toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _conversions.keys
                  .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                  .toList(),
              onChanged: (value) {
                final newCategory = value ?? 'Length';
                final newUnits = _conversions[newCategory]!.keys.toList();
                setState(() {
                  _selectedCategory = newCategory;
                  _fromUnit = newUnits.first;
                  _toUnit = newUnits.length > 1 ? newUnits[1] : newUnits.first;
                  _inputController.clear();
                  _calculated = false;
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text('From', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _fromUnit,
              items: units.map((unit) => DropdownMenuItem(value: unit, child: Text(unit))).toList(),
              onChanged: (value) => setState(() => _fromUnit = value ?? _fromUnit),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text('To', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _toUnit,
              items: units.map((unit) => DropdownMenuItem(value: unit, child: Text(unit))).toList(),
              onChanged: (value) => setState(() => _toUnit = value ?? _toUnit),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text('Enter Value', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _inputController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: 'Enter value', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _convert,
                child: const Text('Convert'),
              ),
            ),
            if (_calculated) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('${_inputController.text} $_fromUnit')),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        '${_result.toStringAsFixed(4)} $_toUnit',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
