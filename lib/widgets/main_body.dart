import 'package:flutter/material.dart';
import '../pages/dashboard_page.dart';
import '../pages/reports_page.dart';
import '../pages/transaction_page.dart';
import '../services/auth_service.dart';
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

            PopupMenuButton<String>(
              color: Colors.white,
              offset: const Offset(0, 40),
              position: PopupMenuPosition.under,
              onSelected: (value) {
                if (value == 'add') {
                  _navigate(context, const TransactionPage(showAddTransactionDialog: true));
                } else if (value == 'view') {
                  _navigate(context, const TransactionPage());
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'add',
                  height: 48,
                  child: const SizedBox(
                    width: 160,
                    child: Text('Add Transaction'),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'view',
                  height: 48,
                  child: const SizedBox(
                    width: 160,
                    child: Text('View Transactions'),
                  ),
                ),
              ],
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Transactions', style: TextStyle(color: Colors.white)),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
            SizedBox(width: 32.0),

            TextButton(
                onPressed: () {
                  _navigate(context, ReportsPage());
                },
                child: Text("Reports")
            ),
            SizedBox(width: 32.0),
            IconButton(
              onPressed: () async {
                // Navigate first to avoid stream errors, then sign out
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
                await AuthService().signOut();
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
            SizedBox(width: 16.0),
          ]
      ),
      body: child,
    );
  }
}

