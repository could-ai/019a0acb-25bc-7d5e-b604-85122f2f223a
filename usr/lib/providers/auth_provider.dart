import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userId;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  String? get token => _token;

  Future<void> login(String phoneNumber, String otp) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = true;
    _userId = 'user123';
    _token = 'fake_token';
    notifyListeners();
  }

  Future<void> register(String name, String phoneNumber, String email) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // Registration logic
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userId = null;
    _token = null;
    notifyListeners();
  }

  Future<void> sendOTP(String phoneNumber) async {
    // Simulate sending OTP
    await Future.delayed(const Duration(seconds: 1));
  }
}