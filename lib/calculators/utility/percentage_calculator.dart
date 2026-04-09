import 'package:flutter/material.dart';

class PercentageCalculator extends StatefulWidget {
  const PercentageCalculator({super.key});

  @override
  State<PercentageCalculator> createState() => _PercentageCalculatorState();
}

class _PercentageCalculatorState extends State<PercentageCalculator> {
  final TextEditingController _baseAmountController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();

  String _calculationType = 'What is X% of Y?';
  double _result = 0;
  bool _calculated = false;

  void _calculate() {
    final baseAmount = double.tryParse(_baseAmountController.text) ?? 0;
    final percentage = double.tryParse(_percentageController.text) ?? 0;

    if (baseAmount < 0 || percentage < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    switch (_calculationType) {
      case 'What is X% of Y?':
        _result = (percentage / 100) * baseAmount;
        break;
      case 'Discount':
        _result = baseAmount - ((percentage / 100) * baseAmount);
        break;
      case 'Markup':
        _result = baseAmount + ((percentage / 100) * baseAmount);
        break;
      case 'Percentage Increase':
        if (baseAmount == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Initial value cannot be zero')),
          );
          return;
        }
        _result = ((percentage - baseAmount) / baseAmount) * 100;
        break;
    }

    setState(() => _calculated = true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calculation Type', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _calculationType,
              items: const [
                'What is X% of Y?',
                'Discount',
                'Markup',
                'Percentage Increase',
              ].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) {
                setState(() {
                  _calculationType = value ?? 'What is X% of Y?';
                  _baseAmountController.clear();
                  _percentageController.clear();
                  _calculated = false;
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            Text(_getFirstInputLabel(), style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _baseAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: 'Enter value', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text(_getSecondInputLabel(), style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _percentageController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: 'Enter value', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                child: const Text('Calculate'),
              ),
            ),
            if (_calculated) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text('Result', style: Theme.of(context).textTheme.titleLarge),
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
                    Text('Answer', style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                      _result.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
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

  String _getFirstInputLabel() {
    switch (_calculationType) {
      case 'What is X% of Y?':
        return 'Base Amount';
      case 'Discount':
        return 'Original Price (\$)';
      case 'Markup':
        return 'Cost Price (\$)';
      case 'Percentage Increase':
        return 'Initial Value';
      default:
        return 'Value';
    }
  }

  String _getSecondInputLabel() {
    switch (_calculationType) {
      case 'What is X% of Y?':
        return 'Percentage (%)';
      case 'Discount':
        return 'Discount (%)';
      case 'Markup':
        return 'Markup (%)';
      case 'Percentage Increase':
        return 'Final Value';
      default:
        return 'Percentage (%)';
    }
  }

  @override
  void dispose() {
    _baseAmountController.dispose();
    _percentageController.dispose();
    super.dispose();
  }
}
