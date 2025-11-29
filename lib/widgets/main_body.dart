import 'package:flutter/material.dart';
import 'package:my_finance_tracker/pages/add_transaction_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/reports_page.dart';
import '../pages/transaction_page.dart';
import '../pages/login_page.dart';

class MainBody extends StatelessWidget {
  final Widget child;

  const MainBody({ required this.child, super.key });

  // Helper method to control page transitions.
  void _navigate(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_,__,___) => page,
          transitionsBuilder: (_,__,___,child) => child,
          transitionDuration: Duration.zero,
        )
    );
  }

  // Main layout displayed on all pages. This contains the navigation menu for users to switch between tabs
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("DollaWiz"),
          actions: [
            // TextButton(
            //     onPressed: () {
            //       _navigate(context, LoginPage());
            //     },
            //     child: Text("Login"),
            // ),
            SizedBox(width: 32.0),
            TextButton(
                onPressed: () {
                  _navigate(context, DashboardPage());
                },
                child: Text("Dashboard")
            ),
            SizedBox(width: 32.0),
            TextButton(
                onPressed: () {
                  _navigate(context, ReportsPage());
                },
                child: Text("Reports")
            ),
            SizedBox(width: 32.0),
            PopupMenuButton<String>(
              color: Colors.white,
              offset: Offset(50, 40),
              onSelected: (value) {
                if (value == 'add') {
                  _navigate(context, AddTransactionPage());
                } else if (value == 'view') {
                  _navigate(context, TransactionPage());
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'add',
                  child: Text('Add Transaction'),
                ),
                const PopupMenuItem<String>(
                  value: 'view',
                  child: Text('View Transactions'),
                ),
              ],
              child: const Text('Transactions', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 32.0),
          ]
      ),
      body: child,
    );
  }
}

