import 'package:flutter/material.dart';

class LoanProvider with ChangeNotifier {
  List<Map<String, dynamic>> _loanProducts = [
    {
      'id': '1',
      'name': 'Personal Loan',
      'description': 'Loan for personal needs',
      'minAmount': 50000,
      'maxAmount': 500000,
      'minTenure': 12,
      'maxTenure': 60,
      'interestRate': 12.5,
    },
    {
      'id': '2',
      'name': 'Quick Loan',
      'description': 'Fast approval loan',
      'minAmount': 10000,
      'maxAmount': 100000,
      'minTenure': 3,
      'maxTenure': 12,
      'interestRate': 15.0,
    },
    {
      'id': '3',
      'name': 'Short-term Loan',
      'description': 'Short duration loan',
      'minAmount': 5000,
      'maxAmount': 50000,
      'minTenure': 1,
      'maxTenure': 6,
      'interestRate': 18.0,
    },
  ];

  List<Map<String, dynamic>> get loanProducts => _loanProducts;

  Future<List<Map<String, dynamic>>> fetchLoanProducts() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return _loanProducts;
  }

  Future<Map<String, dynamic>> applyForLoan(Map<String, dynamic> applicationData) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return {
      'id': 'loan123',
      'status': 'pending',
      'message': 'Application submitted successfully',
    };
  }

  List<Map<String, dynamic>> calculateEMI(double principal, double rate, int tenure) {
    double monthlyRate = rate / 12 / 100;
    double emi = principal * monthlyRate * (1 + monthlyRate).pow(tenure) / ((1 + monthlyRate).pow(tenure) - 1);
    List<Map<String, dynamic>> schedule = [];

    double balance = principal;
    for (int i = 1; i <= tenure; i++) {
      double interest = balance * monthlyRate;
      double principalPayment = emi - interest;
      balance -= principalPayment;
      schedule.add({
        'month': i,
        'emi': emi,
        'principal': principalPayment,
        'interest': interest,
        'balance': balance > 0 ? balance : 0,
      });
    }
    return schedule;
  }

  Future<bool> checkEligibility(double amount, int creditScore) async {
    // Simulate eligibility check
    await Future.delayed(const Duration(seconds: 1));
    return creditScore > 650 && amount <= 100000;
  }
}