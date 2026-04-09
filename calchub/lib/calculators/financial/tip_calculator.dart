import 'package:flutter/material.dart';

class TipCalculator extends StatefulWidget {
  const TipCalculator({Key? key}) : super(key: key);

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bill Amount (\$)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _billController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter bill amount',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tip Percentage', style: Theme.of(context).textTheme.labelLarge),
                Text('${_tipPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
              ],
            ),
            Slider(
              value: _tipPercentage,
              min: 0,
              max: 50,
              divisions: 100,
              label: '${_tipPercentage.toStringAsFixed(0)}%',
              onChanged: (value) {
                setState(() {
                  _tipPercentage = value;
                  if (_billController.text.isNotEmpty) _calculateTip();
                });
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
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_numberOfPeople > 1) {
                            _numberOfPeople--;
                            if (_billController.text.isNotEmpty) _calculateTip();
                          }
                        });
                      },
                    ),
                    Text('$_numberOfPeople', style: Theme.of(context).textTheme.titleMedium),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _numberOfPeople++;
                          if (_billController.text.isNotEmpty) _calculateTip();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _calculateTip, child: const Text('Calculate Tip')),
            ),
            if (_calculated) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text('Summary', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _buildResultRow('Bill Amount', '\$${_billController.text}', context),
              _buildResultRow('Tip Amount', '\$${_tipAmount.toStringAsFixed(2)}', context, highlight: true),
              _buildResultRow('Total with Tip', '\$${_totalWithTip.toStringAsFixed(2)}', context, highlight: true),
              const Divider(),
              _buildResultRow('Per Person ($_numberOfPeople)', '\$${_perPersonAmount.toStringAsFixed(2)}', context, highlight: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, BuildContext context, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            color: highlight ? Theme.of(context).primaryColor : null,
          )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _billController.dispose();
    super.dispose();
  }
}
