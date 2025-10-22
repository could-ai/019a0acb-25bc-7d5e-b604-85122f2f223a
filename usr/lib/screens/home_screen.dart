import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sahay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Sahay',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Secure Loan Lending Platform'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/kyc'),
              child: const Text('Complete KYC'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/loan-products'),
              child: const Text('View Loan Products'),
            ),
            const SizedBox(height: 20),
            if (authProvider.isLoggedIn) // Simulate admin role
              ElevatedButton(
                onPressed: () => context.go('/admin'),
                child: const Text('Admin Panel'),
              ),
          ],
        ),
      ),
    );
  }
}