import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repo/settings_repo.dart';

class SettingsController extends GetxController {
  final SettingsRepo _repo = SettingsRepo();

  final RxString selectedAppearance;
  final RxBool isLoggingOut = false.obs;
  final RxBool isSavingAppearance = false.obs;

  SettingsController({
    required String initialAppearance,
  }) : selectedAppearance = initialAppearance.obs;

  Future<void> changeAppearance(String appearance) async {
    if (isSavingAppearance.value) return;

    if (appearance == selectedAppearance.value) return;

    isSavingAppearance.value = true;

    try {
      await _repo.saveAppearance(appearance);

      selectedAppearance.value = appearance;

      Get.changeThemeMode(
        appearance == 'Dark' ? ThemeMode.dark : ThemeMode.light,
      );
    } catch (e) {
      debugPrint('Appearance error: $e');

      Get.snackbar(
        'Error',
        'Could not save appearance. Please try again.',
      );
    } finally {
      isSavingAppearance.value = false;
    }
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;

    isLoggingOut.value = true;

    try {
      await _repo.logout();

      // Close settings and return to AuthGate.
      Get.until((route) => route.isFirst);
    } catch (e) {
      debugPrint('Logout error: $e');

      Get.snackbar(
        'Error',
        'Could not log out. Please try again.',
      );
    } finally {
      isLoggingOut.value = false;
    }
  }
}