import 'package:flutter/material.dart';
import '../widgets/main_body.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainBody(
        child: Column(
            children: [
              Text("This is the Dashboard Page")
            ]
        )
    );
  }
}