import 'package:flutter/material.dart';

class PercentageCalculator extends StatefulWidget {
  const PercentageCalculator({Key? key}) : super(key: key);

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

    late double result;
    switch (_calculationType) {
      case 'What is X% of Y?':
        result = (percentage / 100) * baseAmount;
        break;
      case 'Discount':
        result = baseAmount - ((percentage / 100) * baseAmount);
        break;
      case 'Markup':
        result = baseAmount + ((percentage / 100) * baseAmount);
        break;
      case 'Percentage Increase':
        result = ((percentage - baseAmount) / baseAmount) * 100;
        break;
      default:
        result = 0;
    }

    setState(() {
      _result = result;
      _calculated = true;
    });
  }

  String _getFirstInputLabel() {
    switch (_calculationType) {
      case 'What is X% of Y?': return 'Base Amount';
      case 'Discount': return 'Original Price (\$)';
      case 'Markup': return 'Cost Price (\$)';
      case 'Percentage Increase': return 'Initial Value';
      default: return 'Value';
    }
  }

  String _getSecondInputLabel() {
    switch (_calculationType) {
      case 'What is X% of Y?': return 'Percentage (%)';
      case 'Discount': return 'Discount (%)';
      case 'Markup': return 'Markup (%)';
      case 'Percentage Increase': return 'Final Value';
      default: return 'Percentage (%)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calculation Type', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: _calculationType,
              onChanged: (String? newValue) {
                setState(() {
                  _calculationType = newValue ?? 'What is X% of Y?';
                  _baseAmountController.clear();
                  _percentageController.clear();
                  _calculated = false;
                });
              },
              items: ['What is X% of Y?', 'Discount', 'Markup', 'Percentage Increase']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
            ),
            const SizedBox(height: 24),
            Text(_getFirstInputLabel(), style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _baseAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter value',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Text(_getSecondInputLabel(), style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _percentageController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter value',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _calculate, child: const Text('Calculate')),
            ),
            if (_calculated) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text('Result', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Answer', style: Theme.of(context).textTheme.bodyMedium),
                    Text(_result.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
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
    _baseAmountController.dispose();
    _percentageController.dispose();
    super.dispose();
  }
}
