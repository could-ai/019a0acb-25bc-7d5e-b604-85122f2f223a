import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulate admin access - in real app, check role
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Loan Management Dashboard',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildAdminCard('Pending Approvals', '5 applications waiting', Icons.pending_actions),
                  _buildAdminCard('Risk Assessment', 'Review high-risk loans', Icons.warning),
                  _buildAdminCard('Payment Monitoring', 'Track payment statuses', Icons.payment),
                  _buildAdminCard('Audit Logs', 'View system activities', Icons.history),
                  _buildAdminCard('User Management', 'Manage roles and permissions', Icons.people),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to detailed view
        },
      ),
    );
  }
}