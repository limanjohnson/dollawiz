import 'package:flutter/material.dart';
import 'package:my_finance_tracker/widgets/add_transaction_dialog.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';
import '../widgets/main_body.dart';
import '../widgets/transaction_dashboard.dart';

class TransactionPage extends StatefulWidget {
  final bool showAddTransactionDialog;

  const TransactionPage({super.key, this.showAddTransactionDialog = false});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _transactionService = TransactionService();
  List<String> _existingAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    if (widget.showAddTransactionDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openAddTransactionDialog();
      });
    }
  }

  Future<void> _loadAccounts() async {
    try {
      final accounts = await _transactionService.getExistingAccounts();
      setState(() {
        _existingAccounts = accounts;
      });
    } catch (e) {
      // User might not be logged in yet
    }
  }

  Future<void> _openAddTransactionDialog() async {
    final transaction = await showAddTransactionDialog(
      context,
      existingAccounts: _existingAccounts,
    );
    if (transaction != null) {
      await _transactionService.addTransaction(transaction);
      _loadAccounts();
    }
  }

  Future<void> _editTransaction(Transaction transaction) async {
    final updated = await showAddTransactionDialog(
      context,
      existingAccounts: _existingAccounts,
      existingTransaction: transaction,
    );
    if (updated != null) {
      await _transactionService.updateTransaction(updated);
      _loadAccounts();
    }
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true && transaction.id != null) {
      await _transactionService.deleteTransaction(transaction.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainBody(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top action buttons
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Reminders')),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _openAddTransactionDialog,
                  child: const Text('+ New'),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: StreamBuilder<List<Transaction>>(
                    stream: _transactionService.transactionsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      final transactions = snapshot.data ?? [];
                      return TransactionDashboard(
                        transactions: transactions,
                        onEdit: _editTransaction,
                        onDelete: _deleteTransaction,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
