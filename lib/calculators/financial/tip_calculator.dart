import 'package:flutter/material.dart';

class TipCalculator extends StatefulWidget {
  const TipCalculator({super.key});

  @override
  State<TipCalculator> createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  final TextEditingController _billController = TextEditingController();

  double _tipPercentage = 15;
  int _numberOfPeople = 1;
  double _tipAmount = 0;
  double _totalWithTip = 0;
  double _perPersonAmount = 0;
  bool _calculated = false;

  void _calculateTip() {
    final billAmount = double.tryParse(_billController.text) ?? 0;

    if (billAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid bill amount')),
      );
      return;
    }

    setState(() {
      _tipAmount = billAmount * (_tipPercentage / 100);
      _totalWithTip = billAmount + _tipAmount;
      _perPersonAmount = _totalWithTip / _numberOfPeople;
      _calculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bill Amount (\$)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _billController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: 'Enter bill amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tip Percentage', style: Theme.of(context).textTheme.labelLarge),
                Text(
                  '${_tipPercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            Slider(
              value: _tipPercentage,
              min: 0,
              max: 50,
              divisions: 100,
              label: '${_tipPercentage.toStringAsFixed(0)}%',
              onChanged: (value) {
                setState(() => _tipPercentage = value);
                if (_billController.text.isNotEmpty) _calculateTip();
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number of People', style: Theme.of(context).textTheme.labelLarge),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_numberOfPeople > 1) {
                          setState(() => _numberOfPeople--);
                          if (_billController.text.isNotEmpty) _calculateTip();
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text('$_numberOfPeople', style: Theme.of(context).textTheme.titleMedium),
                    IconButton(
                      onPressed: () {
                        setState(() => _numberOfPeople++);
                        if (_billController.text.isNotEmpty) _calculateTip();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateTip,
                child: const Text('Calculate Tip'),
              ),
            ),
            if (_calculated) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text('Summary', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _row(context, 'Bill Amount', '\$${_billController.text}'),
              _row(context, 'Tip Amount', '\$${_tipAmount.toStringAsFixed(2)}', true),
              _row(context, 'Total with Tip', '\$${_totalWithTip.toStringAsFixed(2)}', true),
              const Divider(),
              _row(context, 'Per Person ($_numberOfPeople)', '\$${_perPersonAmount.toStringAsFixed(2)}', true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, [bool highlight = false]) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              value,
              style: TextStyle(
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                color: highlight ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    _billController.dispose();
    super.dispose();
  }
}
