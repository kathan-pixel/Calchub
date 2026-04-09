import 'package:flutter/material.dart';

class CalorieCalculator extends StatefulWidget {
  const CalorieCalculator({Key? key}) : super(key: key);

  @override
  State<CalorieCalculator> createState() => _CalorieCalculatorState();
}

class _CalorieCalculatorState extends State<CalorieCalculator> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _gender = 'Male';
  String _activityLevel = 'Sedentary';
  bool _isMetric = true;
  double _bmr = 0;
  double _dailyCalories = 0;
  bool _calculated = false;

  final Map<String, double> _activityMultipliers = {
    'Sedentary': 1.2,
    'Lightly Active': 1.375,
    'Moderately Active': 1.55,
    'Very Active': 1.725,
    'Extremely Active': 1.9,
  };

  void _calculate() {
    final age = int.tryParse(_ageController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;

    if (age <= 0 || weight <= 0 || height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    double weightKg = _isMetric ? weight : weight * 0.453592;
    double heightCm = _isMetric ? height : height * 2.54;

    late double bmr;
    if (_gender == 'Male') {
      bmr = 88.362 + (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * age);
    }

    final dailyCalories = bmr * (_activityMultipliers[_activityLevel] ?? 1.2);

    setState(() {
      _bmr = bmr;
      _dailyCalories = dailyCalories;
      _calculated = true;
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
                Text('Gender', style: Theme.of(context).textTheme.labelLarge),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(label: Text('Male'), value: 'Male'),
                    ButtonSegment(label: Text('Female'), value: 'Female'),
                  ],
                  selected: {_gender},
                  onSelectionChanged: (Set<String> s) => setState(() => _gender = s.first),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Age', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter age',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
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
                  onSelectionChanged: (Set<bool> s) {
                    setState(() {
                      _isMetric = s.first;
                      _weightController.clear();
                      _heightController.clear();
                      _calculated = false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(_isMetric ? 'Weight (kg)' : 'Weight (lbs)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter weight',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Text(_isMetric ? 'Height (cm)' : 'Height (inches)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter height',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Activity Level', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: _activityLevel,
              onChanged: (String? newValue) => setState(() => _activityLevel = newValue ?? 'Sedentary'),
              items: _activityMultipliers.keys
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _calculate, child: const Text('Calculate Calories')),
            ),
            if (_calculated) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text('Results', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BMR (Basal Metabolic Rate)', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text('${_bmr.toStringAsFixed(0)} calories/day',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Calorie Need ($_activityLevel)', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text('${_dailyCalories.toStringAsFixed(0)} calories/day',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.green)),
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
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}
