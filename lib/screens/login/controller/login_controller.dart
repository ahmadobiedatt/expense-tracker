import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../repo/login_repo.dart';

class LoginController extends GetxController {
  final LoginRepo _repo = LoginRepo();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;

  // Return an error message, or null if there is no error to display.
  Future<String?> login() async {
    if (isLoading.value) return null;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      return 'Please enter your email and password.';
    }

    isLoading.value = true;

    try {
      await _repo.login(
        email: email,
        password: password,
      );

      // AuthGate displays HomePage after successful login.
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';

        case 'invalid-email':
          return 'Please enter a valid email.';

        case 'user-disabled':
          return 'This account has been disabled.';

        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';

        case 'network-request-failed':
          return 'Network error. Check your internet connection.';

        default:
          return e.message ?? 'Login failed.';
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return 'Could not log in. Please try again.';
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}