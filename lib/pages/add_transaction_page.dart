import 'package:flutter/material.dart';
import '../widgets/main_body.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  int? _selectedAccountId;
  int? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  bool _isExpense = true;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Handle form submission
  void _saveTransaction() {
    // values from controllers
    final amount = double.tryParse(_amountController.text) ?? 0;
    final description = _descriptionController.text;

    // TODO: Call DatabaseService to save
    print('Amount: $amount');
    print('Description: $description');
    print('Date: $_selectedDate');
  }

  @override
  Widget build(BuildContext context) {
    return MainBody(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Amount
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),

            SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),

            SizedBox(height: 16),

            // Date
            Row(
                children: [
                  Text('Date: ${_selectedDate.month}/${_selectedDate
                      .day}/${_selectedDate.year}'),
                  TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          // rebuild the UI
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                    child: Text('Change'),
                  )
                ]
            ),

            SizedBox(height: 24),

            // Save Button
            ElevatedButton(
                style: Colors.white,
                onPressed: _saveTransaction,
                child: Text("Save Transaction"))
          ],
        ),
      ),
    );
  }
}
