import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';

class LoanProductsScreen extends StatelessWidget {
  const LoanProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<LoanProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Loan Products')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loanProvider.fetchLoanProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final products = snapshot.data ?? [];
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(product['description']),
                      const SizedBox(height: 8),
                      Text('Amount: ₹${product['minAmount']} - ₹${product['maxAmount']}'),
                      Text('Tenure: ${product['minTenure']} - ${product['maxTenure']} months'),
                      Text('Interest Rate: ${product['interestRate']}% p.a.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/apply-loan/${product['id']}'),
                        child: const Text('Apply Now'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/emi-calculator'),
        child: const Icon(Icons.calculate),
        tooltip: 'EMI Calculator',
      ),
    );
  }
}