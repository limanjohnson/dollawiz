import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionDashboard extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(Transaction)? onEdit;
  final Function(Transaction)? onDelete;

  const TransactionDashboard({
    super.key,
    required this.transactions,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No transactions yet. Click "+ New" to add one.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isIncome = transaction.type == TransactionType.income;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isIncome ? Colors.green[100] : Colors.red[100],
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
          title: Text(
            transaction.description.isNotEmpty
                ? transaction.description
                : transaction.contact,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${transaction.category} • ${transaction.account}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Text(
                '${transaction.date.month}/${transaction.date.day}/${transaction.date.year}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              if (transaction.tags.isNotEmpty)
                Wrap(
                  spacing: 4,
                  children: transaction.tags
                      .map((tag) => Chip(
                            label: Text(tag, style: const TextStyle(fontSize: 10)),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ))
                      .toList(),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isIncome ? Colors.green : Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: transaction.status == TransactionStatus.cleared
                          ? Colors.green[50]
                          : Colors.orange[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      transaction.status == TransactionStatus.cleared
                          ? 'Cleared'
                          : 'Pending',
                      style: TextStyle(
                        fontSize: 10,
                        color: transaction.status == TransactionStatus.cleared
                            ? Colors.green[700]
                            : Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit?.call(transaction);
                  } else if (value == 'delete') {
                    onDelete?.call(transaction);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          isThreeLine: true,
        );
      },
    );
  }
}
