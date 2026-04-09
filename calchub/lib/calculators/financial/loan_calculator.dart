import 'package:flutter/material.dart';
import 'dart:math';

class LoanCalculator extends StatefulWidget {
  const LoanCalculator({Key? key}) : super(key: key);

  @override
  State<LoanCalculator> createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();

  String _loanType = 'Personal Loan';
  double _monthlyPayment = 0;
  double _totalPayment = 0;
  double _totalInterest = 0;
  bool _calculated = false;

  void _calculate() {
    final principal = double.tryParse(_principalController.text) ?? 0;
    final annualRate = double.tryParse(_rateController.text) ?? 0;
    final months = int.tryParse(_monthsController.text) ?? 0;

    if (principal <= 0 || annualRate < 0 || months <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    final monthlyRate = annualRate / 100 / 12;

    late double monthly;
    if (monthlyRate == 0) {
      monthly = principal / months;
    } else {
      monthly = principal *
          (monthlyRate * pow(1 + monthlyRate, months)) /
          (pow(1 + monthlyRate, months) - 1);
    }

    setState(() {
      _monthlyPayment = monthly;
      _totalPayment = monthly * months;
      _totalInterest = _totalPayment - principal;
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
            Text('Loan Type', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: _loanType,
              onChanged: (String? newValue) {
                setState(() { _loanType = newValue ?? 'Personal Loan'; });
              },
              items: ['Personal Loan', 'Auto Loan', 'Student Loan', 'Other']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text('Loan Amount (\$)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _principalController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter amount',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Annual Interest Rate (%)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _rateController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter rate',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Loan Term (Months)', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _monthsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter months',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                child: const Text('Calculate Loan'),
              ),
            ),
            if (_calculated) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text('Results', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _buildResultRow('Monthly Payment', '\$${_monthlyPayment.toStringAsFixed(2)}', context),
              _buildResultRow('Total Amount Paid', '\$${_totalPayment.toStringAsFixed(2)}', context),
              _buildResultRow('Total Interest', '\$${_totalInterest.toStringAsFixed(2)}', context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _monthsController.dispose();
    super.dispose();
  }
}
