import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/text_form_field.dart';
import '../controller/home_controller.dart';
import '../../transactions/controller/transactions_controller.dart';
import '../../transactions/view/transactions_page.dart';
import '../../settings/view/settings_page.dart';
import '../../settings/controller/settings_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;

  final Color primaryColor = const Color(0xFF197866);
  final Color lightGreen = const Color(0xFFE2F3EF);

  @override
  void initState() {
    super.initState();

    controller = Get.put(HomeController());
  }

  @override
  void dispose() {
    Get.delete<HomeController>();

    super.dispose();
  }

  Future<void> showTransactionDialog(String type) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _TransactionDialog(
          type: type,
          primaryColor: primaryColor,
          lightGreen: lightGreen,
        );
      },
    );

    if (!mounted || saved != true) return;

    Get.snackbar(
      'Success',
      type == 'income'
          ? 'Balance added successfully!'
          : 'Expense recorded successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );

    await controller.loadBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Tracker',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: primaryColor,
            ),
            onPressed: () {
              Get.dialog(
                Align(
                  alignment: Alignment.centerRight,
                  child: const _SettingsPanel(),
                ),
                barrierColor: Colors.black54,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.pie_chart_outline,
                  color: Color(0xFF197866),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your money, organized',
                    style: TextStyle(
                      color: Color(0xFF197866),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 55),

            // Current balance.
            Container(
              width: double.infinity,
              height: 150,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Current balance',
                    style: TextStyle(
                      color: Color(0xFF197866),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(
                    () => controller.isLoading.value
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Color(0xFF197866),
                            ),
                          )
                        : Text(
                            '${controller.balance.value.toStringAsFixed(2)} JOD',
                            style: const TextStyle(
                              color: Color(0xFF197866),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Income and expense buttons.
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showTransactionDialog('income');
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Add Balance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightGreen,
                      foregroundColor: primaryColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showTransactionDialog('expense');
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    label: const Text('Add Expense'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF8E3E3),
                      foregroundColor: const Color(0xFFAD5555),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        indicatorColor: lightGreen,
        onDestinationSelected: (index) {
          if (index == 1) {
            Get.to(() => const TransactionsPage());
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home,
              color: primaryColor,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(
              Icons.receipt_long,
              color: primaryColor,
            ),
            label: 'Transactions',
          ),
        ],
      ),
    );
  }
}

// Uses its own context so the panel follows theme changes.
class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Obx(() {
      final isDark =
          controller.selectedAppearance.value == 'Dark';

      final brightness =
          isDark ? Brightness.dark : Brightness.light;

      final backgroundColor =
          isDark ? const Color(0xFF121212) : Colors.white;

      return Theme(
        data: ThemeData(
          brightness: brightness,
          scaffoldBackgroundColor: backgroundColor,
          primaryColor: const Color(0xFF197866),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF197866),
            brightness: brightness,
          ),
        ),
        child: Material(
          color: backgroundColor,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.80,
            height: double.infinity,
            child: const SettingsPage(),
          ),
        ),
      );
    });
  }
}

class _TransactionDialog extends StatefulWidget {
  final String type;
  final Color primaryColor;
  final Color lightGreen;

  const _TransactionDialog({
    required this.type,
    required this.primaryColor,
    required this.lightGreen,
  });

  @override
  State<_TransactionDialog> createState() =>
      _TransactionDialogState();
}

class _TransactionDialogState extends State<_TransactionDialog> {
  late final TransactionsController transactionsController;

  final TextEditingController amountController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool get isIncome => widget.type == 'income';

  @override
  void initState() {
    super.initState();

    transactionsController = Get.put(TransactionsController());
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();

    Get.delete<TransactionsController>();

    super.dispose();
  }

  Future<void> saveTransaction() async {
    if (transactionsController.isSaving.value) return;

    if (!formKey.currentState!.validate()) return;

    final amount = double.parse(amountController.text.trim());
    final description = descriptionController.text.trim();

    final message = await transactionsController.addTransaction(
      amount: amount,
      type: widget.type,
      description: description,
    );

    if (!mounted) return;

    if (message != null) {
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        isIncome ? 'Add Balance' : 'Add Expense',
        style: TextStyle(
          color: widget.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                hintText: 'Enter amount',
                labelText: 'Amount (JOD)',
                myController: amountController,
                prefixIcon: Icons.payments_outlined,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  final amount =
                      double.tryParse(value?.trim() ?? '');

                  if (amount == null ||
                      !amount.isFinite ||
                      amount <= 0) {
                    return 'Enter a valid amount';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                hintText: 'e.g. Salary, Food',
                labelText: 'Description',
                myController: descriptionController,
                prefixIcon: Icons.description_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a description';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        Obx(
          () => TextButton(
            onPressed: transactionsController.isSaving.value
                ? null
                : () {
                    Navigator.of(context).pop();
                  },
            style: TextButton.styleFrom(
              foregroundColor: widget.primaryColor,
            ),
            child: const Text('Cancel'),
          ),
        ),
        Obx(
          () => ElevatedButton(
            onPressed: transactionsController.isSaving.value
                ? null
                : saveTransaction,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.lightGreen,
              foregroundColor: widget.primaryColor,
              disabledBackgroundColor: widget.lightGreen,
              disabledForegroundColor: Colors.grey,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }
}