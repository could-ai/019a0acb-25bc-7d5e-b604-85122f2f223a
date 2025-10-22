import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';

class ApplyLoanScreen extends StatefulWidget {
  final String productId;

  const ApplyLoanScreen({super.key, required this.productId});

  @override
  State<ApplyLoanScreen> createState() => _ApplyLoanScreenState();
}

class _ApplyLoanScreenState extends State<ApplyLoanScreen> {
  final _amountController = TextEditingController();
  final _tenureController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _product;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final loanProvider = Provider.of<LoanProvider>(context, listen: false);
    final products = await loanProvider.fetchLoanProducts();
    setState(() {
      _product = products.firstWhere((p) => p['id'] == widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Apply for ${_product!['name']}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Loan Amount (₹${_product!['minAmount']} - ₹${_product!['maxAmount']})',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tenureController,
              decoration: InputDecoration(
                labelText: 'Tenure (${_product!['minTenure']} - ${_product!['maxTenure']} months)',
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _applyLoan,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Submit Application'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _applyLoan() async {
    final amount = double.tryParse(_amountController.text);
    final tenure = int.tryParse(_tenureController.text);

    if (amount == null || tenure == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid amount and tenure')),
      );
      return;
    }

    // Check eligibility
    final loanProvider = Provider.of<LoanProvider>(context, listen: false);
    final isEligible = await loanProvider.checkEligibility(amount, 700); // Assume credit score

    if (!isEligible) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are not eligible for this loan')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await loanProvider.applyForLoan({
        'productId': widget.productId,
        'amount': amount,
        'tenure': tenure,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      context.go('/payment/${result['id']}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application failed: $e')),
      );
    }
    setState(() => _isLoading = false);
  }
}