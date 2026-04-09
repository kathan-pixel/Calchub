import 'dart:math';
import 'package:flutter/material.dart';

class MortgageCalculator extends StatefulWidget {
  const MortgageCalculator({super.key});

  @override
  State<MortgageCalculator> createState() => _MortgageCalculatorState();
}

class _MortgageCalculatorState extends State<MortgageCalculator> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  double _monthlyPayment = 0;
  double _totalPayment = 0;
  double _totalInterest = 0;
  bool _calculated = false;

  void _calculate() {
    final principal = double.tryParse(_principalController.text) ?? 0;
    final annualRate = double.tryParse(_rateController.text) ?? 0;
    final years = int.tryParse(_yearsController.text) ?? 0;

    if (principal <= 0 || annualRate < 0 || years <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    final monthlyRate = annualRate / 100 / 12;
    final numPayments = years * 12;

    final monthly = monthlyRate == 0
        ? principal / numPayments
        : principal *
            (monthlyRate * pow(1 + monthlyRate, numPayments)) /
            (pow(1 + monthlyRate, numPayments) - 1);

    setState(() {
      _monthlyPayment = monthly;
      _totalPayment = monthly * numPayments;
      _totalInterest = _totalPayment - principal;
      _calculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _FormShell(
      children: [
        _label(context, 'Loan Amount (\$)'),
        _field(_principalController, 'e.g., 300000'),
        _label(context, 'Annual Interest Rate (%)'),
        _field(_rateController, 'e.g., 5.5', decimal: true),
        _label(context, 'Loan Term (Years)'),
        _field(_yearsController, 'e.g., 30'),
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
          Text('Results', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _resultRow(context, 'Monthly Payment', '\$${_monthlyPayment.toStringAsFixed(2)}'),
          _resultRow(context, 'Total Payment', '\$${_totalPayment.toStringAsFixed(2)}'),
          _resultRow(context, 'Total Interest', '\$${_totalInterest.toStringAsFixed(2)}'),
        ]
      ],
    );
  }

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _yearsController.dispose();
    super.dispose();
  }
}

class _FormShell extends StatelessWidget {
  final List<Widget> children;
  const _FormShell({required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

Widget _label(BuildContext context, String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(text, style: Theme.of(context).textTheme.labelLarge),
    );

Widget _field(TextEditingController controller, String hint, {bool decimal = false}) =>
    TextField(
      controller: controller,
      keyboardType: decimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

Widget _resultRow(BuildContext context, String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
