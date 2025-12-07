import 'package:flutter/material.dart';
import '../models/transaction.dart';

Future<Transaction?> showAddTransactionDialog(
  BuildContext context, {
  List<String> existingAccounts = const [],
  Transaction? existingTransaction,
}) {
  return showDialog<Transaction>(
    context: context,
    builder: (context) => AddTransactionDialog(
      existingAccounts: existingAccounts,
      existingTransaction: existingTransaction,
    ),
  );
}

class AddTransactionDialog extends StatefulWidget {
  final List<String> existingAccounts;
  final Transaction? existingTransaction;

  const AddTransactionDialog({
    super.key,
    this.existingAccounts = const [],
    this.existingTransaction,
  });

  bool get isEditing => existingTransaction != null;

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _contactController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _accountController = TextEditingController();
  final _tagsController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TransactionType _selectedType = TransactionType.expense;
  TransactionStatus _selectedStatus = TransactionStatus.pending;

  @override
  void initState() {
    super.initState();
    if (widget.existingTransaction != null) {
      final t = widget.existingTransaction!;
      _contactController.text = t.contact;
      _amountController.text = t.amount.toString();
      _descriptionController.text = t.description;
      _categoryController.text = t.category;
      _accountController.text = t.account;
      _tagsController.text = t.tags.join(', ');
      _notesController.text = t.notes ?? '';
      _selectedDate = t.date;
      _selectedType = t.type;
      _selectedStatus = t.status;
    }
  }

  @override
  void dispose() {
    _contactController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _accountController.dispose();
    _tagsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Handle form submission
  void _saveTransaction() {
    // values from controllers
    final contact = _contactController.text;
    final amount = double.tryParse(_amountController.text) ?? 0;
    final description = _descriptionController.text;
    final category = _categoryController.text;
    final account = _accountController.text;
    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    final notes = _notesController.text.isEmpty ? null : _notesController.text;

    final transaction = Transaction(
      id: widget.existingTransaction?.id,
      contact: contact,
      amount: amount,
      description: description,
      category: category,
      date: _selectedDate,
      account: account,
      type: _selectedType,
      status: _selectedStatus,
      tags: tags,
      notes: notes,
    );

    Navigator.pop(context, transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEditing ? 'Edit Transaction' : 'New Transaction',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),

                // Type (Income/Expense)
                Row(
                  children: [
                    const Text('Type: '),
                    const SizedBox(width: 8),
                    SegmentedButton<TransactionType>(
                      segments: const [
                        ButtonSegment(
                          value: TransactionType.expense,
                          label: Text('Expense'),
                        ),
                        ButtonSegment(
                          value: TransactionType.income,
                          label: Text('Income'),
                        ),
                      ],
                      selected: {_selectedType},
                      onSelectionChanged: (Set<TransactionType> selected) {
                        setState(() {
                          _selectedType = selected.first;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Account
                Autocomplete(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return widget.existingAccounts;
                      }
                      return widget.existingAccounts.where((account) =>
                          account.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (String selection) {
                      _accountController.text = selection;
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      // Sync with controller
                      controller.addListener(() {
                        _accountController.text = controller.text;
                      });
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          labelText: 'Account',
                          hintText: 'e.g., Checking, Savings, CreditCard',
                        ),
                      );
                    },
                ),
                const SizedBox(height: 16),

                // Contact
                TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Contact'),
                ),
                const SizedBox(height: 16),

                // Amount
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
                const SizedBox(height: 16),

                // Description
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),

                // Category
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'e.g., Groceries, Utilities, Salary',
                  ),
                ),
                const SizedBox(height: 16),

                // Status
                DropdownMenu<TransactionStatus>(
                  initialSelection: _selectedStatus,
                  label: const Text('Status'),
                  onSelected: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                      value: TransactionStatus.pending,
                      label: 'Pending',
                    ),
                    DropdownMenuEntry(
                      value: TransactionStatus.cleared,
                      label: 'Cleared',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tags
                TextField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'Comma-separated (e.g., vacation, reimbursable)',
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                TextField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                ),
                const SizedBox(height: 16),

                // Date
                Row(
                  children: [
                    Text(
                      'Date: ${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF579C79),
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: const Text('Change'),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                // Save Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF579C79),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saveTransaction,
                      child: Text(widget.isEditing ? "Save" : "Add"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
