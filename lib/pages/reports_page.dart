import 'package:flutter/material.dart';
import '../widgets/main_body.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainBody(
        child: Column(
            children: [
              Text("This is the Reports Page")
            ]
        )
    );
  }
}