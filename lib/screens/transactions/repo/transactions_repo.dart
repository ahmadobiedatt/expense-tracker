import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionsRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTransaction({
    required String userid,
    required double amount,
    required String type,
    required String description,
  }) async {
    if (!amount.isFinite || amount <= 0) {
      throw Exception('Invalid amount.');
    }

    if (type != 'income' && type != 'expense') {
      throw Exception('Invalid transaction type.');
    }

    if (description.trim().isEmpty) {
      throw Exception('Description is required.');
    }

    final userRef = _firestore.collection('users').doc(userid);

    final transactionRef = userRef.collection('transactions').doc();

    await _firestore.runTransaction((transaction) async {
      final userData = await transaction.get(userRef);

      if (!userData.exists) {
        throw Exception('User document not found.');
      }

      final data = userData.data()!;

      final currentBalance =
          (data['balance'] as num?)?.toDouble() ?? 0.0;

      if (!currentBalance.isFinite || currentBalance < 0) {
        throw Exception('Invalid current balance.');
      }

      final isIncome = type == 'income';

      if (!isIncome && amount > currentBalance) {
        throw Exception('Insufficient balance.');
      }

      final newBalance = isIncome
          ? currentBalance + amount
          : currentBalance - amount;

      if (!newBalance.isFinite) {
        throw Exception('Invalid new balance.');
      }

      transaction.update(userRef, {
        'balance': newBalance,
      });

      transaction.set(transactionRef, {
        'amount': amount,
        'type': type,
        'description': description.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<List<Map<String, dynamic>>> getTransactions(
    String userid,
  ) async {
    final transactionsData = await _firestore
        .collection('users')
        .doc(userid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .get();

    final List<Map<String, dynamic>> transactions = [];

    for (final document in transactionsData.docs) {
      final data = document.data();

      transactions.add({
        ...data,
        'id': document.id,
      });
    }

    return transactions;
  }
}
