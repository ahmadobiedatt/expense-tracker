import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/transactions_controller.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late final TransactionsController controller;

  final Color primaryColor = const Color(0xFF197866);
  final Color lightGreen = const Color(0xFFE2F3EF);

  @override
  void initState() {
    super.initState();

    controller = Get.put(
      TransactionsController(),
      tag: 'transactions_page',
    );

    controller.loadTransactions();
  }

  @override
  void dispose() {
    Get.delete<TransactionsController>(
      tag: 'transactions_page',
    );

    super.dispose();
  }

  String formatDate(dynamic value) {
    if (value is! Timestamp) {
      return 'Date unavailable';
    }

    final date = value.toDate();

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: primaryColor,
        title: Text(
          'Transactions',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.loadTransactions();
            },
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.transactions.isEmpty) {
            return const Center(
              child: Text(
                'No transactions to display.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: controller.transactions.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 12);
            },
            itemBuilder: (context, index) {
              final transaction = controller.transactions[index];

              final isIncome = transaction['type'] == 'income';

              final amount =
                  (transaction['amount'] as num?)?.toDouble() ?? 0.0;

              final description =
                  transaction['description']?.toString() ?? '';

              final date = formatDate(transaction['createdAt']);

              final color = isIncome
                  ? primaryColor
                  : const Color(0xFFAD5555);

              final backgroundColor = isIncome
                  ? lightGreen
                  : const Color(0xFFF8E3E3);

              return Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Icon(
                    isIncome
                        ? Icons.add_circle_outline
                        : Icons.remove_circle_outline,
                    color: color,
                    size: 30,
                  ),
                  title: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${isIncome ? 'Income' : 'Expense'} • $date',
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                    ),
                  ),
                  trailing: Text(
                    '${isIncome ? '+' : '-'}'
                    '${amount.toStringAsFixed(2)} JOD',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}