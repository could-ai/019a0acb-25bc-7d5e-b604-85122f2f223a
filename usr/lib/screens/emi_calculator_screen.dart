import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';

class EMICalculatorScreen extends StatefulWidget {
  const EMICalculatorScreen({super.key});

  @override
  State<EMICalculatorScreen> createState() => _EMICalculatorScreenState();
}

class _EMICalculatorScreenState extends State<EMICalculatorScreen> {
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _tenureController = TextEditingController();
  List<Map<String, dynamic>> _schedule = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _principalController,
              decoration: const InputDecoration(
                labelText: 'Principal Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rateController,
              decoration: const InputDecoration(
                labelText: 'Annual Interest Rate (%)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tenureController,
              decoration: const InputDecoration(
                labelText: 'Tenure (months)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculateEMI,
              child: const Text('Calculate EMI'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _schedule.isNotEmpty
                  ? ListView.builder(
                      itemCount: _schedule.length,
                      itemBuilder: (context, index) {
                        final item = _schedule[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Month ${item['month']}'),
                                Text('EMI: ₹${item['emi'].toStringAsFixed(2)}'),
                                Text('Principal: ₹${item['principal'].toStringAsFixed(2)}'),
                                Text('Interest: ₹${item['interest'].toStringAsFixed(2)}'),
                                Text('Balance: ₹${item['balance'].toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text('Enter details and calculate EMI')),
            ),
          ],
        ),
      ),
    );
  }

  void _calculateEMI() {
    final principal = double.tryParse(_principalController.text);
    final rate = double.tryParse(_rateController.text);
    final tenure = int.tryParse(_tenureController.text);

    if (principal == null || rate == null || tenure == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
      return;
    }

    final loanProvider = Provider.of<LoanProvider>(context, listen: false);
    setState(() {
      _schedule = loanProvider.calculateEMI(principal, rate, tenure);
    });
  }
}