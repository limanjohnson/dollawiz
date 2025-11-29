import 'package:flutter/material.dart';
import '../widgets/main_body.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainBody(
        child: Column(
            children: [
              Text("This is the Transaction Page")
            ]
        )
    );
  }
}