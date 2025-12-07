import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { income, expense }

enum TransactionStatus { pending, cleared }

class Transaction {
  final String? id; // Firestore document ID
  final String contact;
  final double amount;
  final String description;
  final String category;
  final DateTime date;
  final String account;
  final TransactionType type;
  final TransactionStatus status;
  final List<String> tags;
  final String? notes;

  Transaction({
    this.id,
    required this.contact,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
    required this.account,
    required this.type,
    this.status = TransactionStatus.pending,
    this.tags = const [],
    this.notes,
  });

  // Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'contact': contact,
      'amount': amount,
      'description': description,
      'category': category,
      'date': Timestamp.fromDate(date),
      'account': account,
      'type': type.name,
      'status': status.name,
      'tags': tags,
      'notes': notes,
    };
  }

  // Create from Firestore document
  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Transaction(
      id: doc.id,
      contact: data['contact'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      account: data['account'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => TransactionType.expense,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => TransactionStatus.pending,
      ),
      tags: List<String>.from(data['tags'] ?? []),
      notes: data['notes'],
    );
  }
}
