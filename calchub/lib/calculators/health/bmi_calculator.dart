import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({Key? key}) : super(key: key);

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  bool _isMetric = true;
  double? _bmi;
  String _category = '';
  Color _categoryColor = Colors.grey;

  void _calculate() {
    final height = double.tryParse(_heightController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;

    if (height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    double bmi;
    if (_isMetric) {
      bmi = weight / ((height / 100) * (height / 100));
    } else {
      bmi = (weight / (height * height)) * 703;
    }

    String category;
    Color color;
    if (bmi < 18.5) { category = 'Underweight'; color = Colors.blue; }
    else if (bmi < 25) { category = 'Normal Weight'; color = Colors.green; }
    else if (bmi < 30) { category = 'Overweight'; color = Colors.orange; }
    else { category = 'Obese'; color = Colors.red; }

    setState(() {
      _bmi = bmi;
      _category = category;
      _categoryColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Unit System', style: Theme.of(context).textTheme.labelLarge),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(label: Text('Metric'), value: true),
                    ButtonSegment(label: Text('Imperial'), value: false),
                  ],
                  selected: {_isMetric},
                  onSelectionChanged: (Set<bool> newSelection) {
                    setState(() {
                      _isMetric = newSelection.first;
                      _heightController.clear();
                      _weightController.clear();
                      _bmi = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(_isMetric ? 'Height (cm)' : 'Height (inches)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: _isMetric ? 'e.g., 170' : 'e.g., 67',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Text(_isMetric ? 'Weight (kg)' : 'Weight (lbs)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: _isMetric ? 'e.g., 70' : 'e.g., 155',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _calculate, child: const Text('Calculate BMI')),
            ),
            if (_bmi != null) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _categoryColor, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text('BMI', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      Text(_bmi!.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: _categoryColor, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(_category, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: _categoryColor)),
                    ],
                  ),
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
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
