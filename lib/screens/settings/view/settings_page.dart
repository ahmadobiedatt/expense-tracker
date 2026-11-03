import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/custombutton.dart';
import '../controller/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    const primaryColor = Color(0xFF197866);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 30),

            // Currency.
            const Row(
              children: [
                Icon(
                  Icons.currency_exchange,
                  color: primaryColor,
                ),
                SizedBox(width: 10),
                Text(
                  'Currency',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'JOD - Jordanian Dinar',
            ),
            const SizedBox(height: 30),

            // Appearance.
            const Row(
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  color: primaryColor,
                ),
                SizedBox(width: 10),
                Text(
                  'Appearance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Obx(
              () => RadioListTile<String>(
                title: const Text('Light Mode'),
                value: 'Light',
                groupValue: controller.selectedAppearance.value,
                activeColor: primaryColor,
                onChanged: controller.isSavingAppearance.value
                    ? null
                    : (value) {
                        if (value == null) return;

                        controller.changeAppearance(value);
                      },
              ),
            ),
            Obx(
              () => RadioListTile<String>(
                title: const Text('Dark Mode'),
                value: 'Dark',
                groupValue: controller.selectedAppearance.value,
                activeColor: primaryColor,
                onChanged: controller.isSavingAppearance.value
                    ? null
                    : (value) {
                        if (value == null) return;

                        controller.changeAppearance(value);
                      },
              ),
            ),
            const SizedBox(height: 40),

            // Logout.
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => CustomButton(
                  title: 'Logout',
                  icon: Icons.logout,
                  color: const Color(0xFFF8E3E3),
                  textColor: const Color(0xFFAD5555),
                  onPressed: controller.isLoggingOut.value
                      ? null
                      : () {
                          controller.logout();
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}