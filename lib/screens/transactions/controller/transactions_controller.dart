import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repo/transactions_repo.dart';

class TransactionsController extends GetxController {
  final TransactionsRepo _repo = TransactionsRepo();

  final RxBool isSaving = false.obs;

  final RxList<Map<String, dynamic>> transactions =
      <Map<String, dynamic>>[].obs;

  Future<void> loadTransactions() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      transactions.clear();
      return;
    }

    try {
      final data = await _repo.getTransactions(user.uid);

      if (isClosed) return;

      transactions.assignAll(data);
    } catch (e) {
      debugPrint('Load transactions error: $e');

      if (isClosed) return;

      Get.snackbar(
        'Error',
        'Could not load transactions. Please try again.',
      );
    }
  }

  Future<String?> addTransaction({
    required double amount,
    required String type,
    required String description,
  }) async {
    if (isSaving.value) {
      return 'Please wait until the current transaction finishes.';
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return 'Please log in first.';
    }

    if (!amount.isFinite || amount <= 0) {
      return 'Enter a valid amount.';
    }

    if (description.trim().isEmpty) {
      return 'Enter a description.';
    }

    if (type != 'income' && type != 'expense') {
      return 'Invalid transaction type.';
    }

    isSaving.value = true;

    try {
      await _repo.addTransaction(
        userid: user.uid,
        amount: amount,
        type: type,
        description: description.trim(),
      );

      debugPrint('Transaction saved successfully.');

      return null;
    } on FirebaseException catch (e) {
      debugPrint(
        'Firebase error: ${e.code} - ${e.message}',
      );

      switch (e.code) {
        case 'permission-denied':
          return 'You do not have permission to save this transaction.';

        case 'unavailable':
          return 'Service unavailable. Please try again.';

        default:
          return 'Could not save the transaction. Please try again.';
      }
    } catch (e) {
      debugPrint('Transaction error: $e');

      if (e.toString().contains('Insufficient balance')) {
        return 'Your balance is not enough.';
      }

      return 'Could not save the transaction. Please try again.';
    } finally {
      if (!isClosed) {
        isSaving.value = false;
      }
    }
  }
}