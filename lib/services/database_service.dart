import 'package:drift/drift.dart';
import 'package:my_finance_tracker/database/database.dart';


class DatabaseService {
  // Accounts
  Future<int> addAccount(String name) async {
    return await database.into(database.accounts).insert(
      AccountsCompanion.insert(name: name),
    );
  }

  Future<List<Account>> getAllAccounts() async {
    return await database.select(database.accounts).get();
  }

  Stream<List<Account>> watchAccounts() {
    return database.select(database.accounts).watch();
  }

  // Categories
  Future<int> addCategory(String name, {bool isIncome = false}) async {
    return await database.into(database.categories).insert(
      CategoriesCompanion.insert(name: name, isIncome: Value(isIncome)),
    );
  }

  Future<List<Category>> getAllCategories() async {
    return await database.select(database.categories).get();
  }

  Stream<List<Category>> watchCategories() {
    return database.select(database.categories).watch();
  }

  // Transactions
  Future<int> addTransaction({
    required double amount,
    required DateTime date,
    required int accountId,
    required int categoryId,
    String? description,
  }) async {
    return await database.into(database.transactions).insert(
      TransactionsCompanion.insert(
        amount: amount,
        date: date,
        accountId: accountId,
        categoryId: categoryId,
        description: Value(description),
      ),
    );
  }

  Future<List<Transaction>> getAllTransactions() async {
    return await database.select(database.transactions).get();
  }

  Stream<List<Transaction>> watchTransactions() {
    return database.select(database.transactions).watch();
  }
}