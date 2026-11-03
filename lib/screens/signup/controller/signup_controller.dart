import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../repo/signup_repo.dart';

class SignupController extends GetxController {
  final SignupRepo _repo = SignupRepo();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;

  Future<String?> signup() async {
    if (isLoading.value) return null;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {

      return 'Please fill in all fields.';

    }

    isLoading.value = true;

    try {
      await _repo.signUp(
        username: name,
        email: email,
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email is already registered.';

        case 'weak-password':
          return 'Password is too weak.';

        case 'invalid-email':
          return 'Please enter a valid email.';

        case 'operation-not-allowed':
          return 'Email/password sign-up is not enabled in Firebase.';

        case 'network-request-failed':
          return 'Network error. Check your internet connection.';

        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';

        default:
          return e.message ?? 'Could not create account.';
      }
    } on FirebaseException catch (e) {
      log('Could not save user data: ${e.code}', error: e);

      return 'Could not save user data. Please try again.';
    } catch (e) {
      log('Sign up failed', error: e);

      return 'Could not complete registration. Please try again.';
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}