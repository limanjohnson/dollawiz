import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../models/transaction.dart';
import 'auth_service.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // Get the transactions collection for the current user
  CollectionReference<Map<String, dynamic>> get _transactionsCollection {
    final userId = _authService.userId;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return _firestore.collection('users').doc(userId).collection('transactions');
  }

  // Get transactions stream (real-time updates)
  Stream<List<Transaction>> get transactionsStream {
    return _transactionsCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transaction.fromFirestore(doc))
            .toList());
  }

  // Get transactions once
  Future<List<Transaction>> getTransactions() async {
    final snapshot = await _transactionsCollection
        .orderBy('date', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => Transaction.fromFirestore(doc))
        .toList();
  }

  // Get existing accounts for autocomplete
  Future<List<String>> getExistingAccounts() async {
    final transactions = await getTransactions();
    return transactions
        .map((t) => t.account)
        .where((a) => a.isNotEmpty)
        .toSet()
        .toList();
  }

  // Add a transaction
  Future<void> addTransaction(Transaction transaction) async {
    await _transactionsCollection.add(transaction.toMap());
  }

  // Update a transaction
  Future<void> updateTransaction(Transaction transaction) async {
    if (transaction.id == null) {
      throw Exception('Transaction ID is required for update');
    }
    await _transactionsCollection.doc(transaction.id).update(transaction.toMap());
  }

  // Delete a transaction
  Future<void> deleteTransaction(String transactionId) async {
    await _transactionsCollection.doc(transactionId).delete();
  }
}
