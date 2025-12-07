import 'package:flutter/material.dart';
import '../models/transaction.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final int limit;

  const RecentTransactionsList({
    required this.transactions,
    this.limit = 5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sortedTransactions = List<Transaction>.from(transactions)
        ..sort((a,b) => b.date.compareTo(a.date));
    final recentTransactions = sortedTransactions.take(limit).toList();

    if (recentTransactions.isEmpty) {
      return const Padding (
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No transactions yet',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: recentTransactions
          .map((t) => _TransactionRow(transaction: t))
          .toList(),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final Transaction transaction;

  const _TransactionRow({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? Colors.green[700] : Colors.red[700];
    final amountPrefix = isIncome ? '+' : '-';

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (isIncome ? Colors.green : Colors.red).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: isIncome ? Colors.green : Colors.red,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description.isNotEmpty
                          ? transaction.description
                          : transaction.contact,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _formatDate(transaction.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
            ),
            Text(
              '$amountPrefix\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: amountColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}