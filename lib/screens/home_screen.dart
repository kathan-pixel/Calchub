import 'package:flutter/material.dart';
import '../models/calculator.dart';
import '../calculators/financial/mortgage_calculator.dart';
import '../calculators/financial/loan_calculator.dart';
import '../calculators/financial/tip_calculator.dart';
import '../calculators/health/bmi_calculator.dart';
import '../calculators/health/calorie_calculator.dart';
import '../calculators/utility/unit_converter.dart';
import '../calculators/utility/percentage_calculator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = -1;

  final List<Calculator> calculators = [
    Calculator(
      id: 'mortgage',
      name: 'Mortgage',
      description: 'Calculate monthly payments',
      category: CalculatorCategory.financial,
      icon: Icons.home,
      builder: (context) => const MortgageCalculator(),
    ),
    Calculator(
      id: 'loan',
      name: 'Loan Calculator',
      description: 'Auto & personal loans',
      category: CalculatorCategory.financial,
      icon: Icons.account_balance,
      builder: (context) => const LoanCalculator(),
    ),
    Calculator(
      id: 'tip',
      name: 'Tip Calculator',
      description: 'Split bills & tips',
      category: CalculatorCategory.financial,
      icon: Icons.restaurant,
      builder: (context) => const TipCalculator(),
    ),
    Calculator(
      id: 'bmi',
      name: 'BMI Calculator',
      description: 'Body mass index',
      category: CalculatorCategory.health,
      icon: Icons.favorite,
      builder: (context) => const BMICalculator(),
    ),
    Calculator(
      id: 'calorie',
      name: 'Calorie Calculator',
      description: 'Daily calorie needs',
      category: CalculatorCategory.health,
      icon: Icons.local_fire_department,
      builder: (context) => const CalorieCalculator(),
    ),
    Calculator(
      id: 'unit_converter',
      name: 'Unit Converter',
      description: 'Length, weight, temp',
      category: CalculatorCategory.utility,
      icon: Icons.straighten,
      builder: (context) => const UnitConverter(),
    ),
    Calculator(
      id: 'percentage',
      name: 'Percentage Calc',
      description: 'Discounts & markup',
      category: CalculatorCategory.utility,
      icon: Icons.percent,
      builder: (context) => const PercentageCalculator(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == -1
        ? calculators
        : calculators
            .where((c) => c.category.index == _selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CalcHub'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('All', -1),
                    _buildCategoryChip('Financial', 0),
                    _buildCategoryChip('Health', 1),
                    _buildCategoryChip('Utility', 2),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final calc = filtered[index];
                  return Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CalculatorDetailScreen(calculator: calc),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              calc.icon,
                              size: 36,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              calc.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              calc.description,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: _selectedCategory == index,
        onSelected: (_) {
          setState(() {
            _selectedCategory = index;
          });
        },
      ),
    );
  }
}

class CalculatorDetailScreen extends StatelessWidget {
  final Calculator calculator;

  const CalculatorDetailScreen({super.key, required this.calculator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(calculator.name)),
      body: calculator.builder(context),
    );
  }
}
