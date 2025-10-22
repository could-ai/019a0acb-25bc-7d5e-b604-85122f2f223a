import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/kyc_screen.dart';
import 'screens/loan_products_screen.dart';
import 'screens/apply_loan_screen.dart';
import 'screens/emi_calculator_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/admin_panel_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/loan_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
      ],
      child: const SahayApp(),
    ),
  );
}

class SahayApp extends StatelessWidget {
  const SahayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/kyc',
          builder: (context, state) => const KYCScreen(),
        ),
        GoRoute(
          path: '/loan-products',
          builder: (context, state) => const LoanProductsScreen(),
        ),
        GoRoute(
          path: '/apply-loan/:productId',
          builder: (context, state) => ApplyLoanScreen(
            productId: state.pathParameters['productId']!,
          ),
        ),
        GoRoute(
          path: '/emi-calculator',
          builder: (context, state) => const EMICalculatorScreen(),
        ),
        GoRoute(
          path: '/payment/:loanId',
          builder: (context, state) => PaymentScreen(
            loanId: state.pathParameters['loanId']!,
          ),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminPanelScreen(),
        ),
      ],
      redirect: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final isLoggedIn = authProvider.isLoggedIn;
        final isOnLoginPage = state.matchedLocation == '/login';
        final isOnRegisterPage = state.matchedLocation == '/register';

        if (!isLoggedIn && !isOnLoginPage && !isOnRegisterPage) {
          return '/login';
        }
        if (isLoggedIn && (isOnLoginPage || isOnRegisterPage)) {
          return '/loan-products';
        }
        return null;
      },
    );

    return MaterialApp.router(
      title: 'Sahay - Secure Loan Lending',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: router,
    );
  }
}