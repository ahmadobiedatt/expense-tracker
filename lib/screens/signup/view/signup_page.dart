import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/text_form_field.dart';
import '../../../components/custombutton.dart';
import '../controller/signup_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late final SignupController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SignupController());
  }

  @override
  void dispose() {
    Get.delete<SignupController>();
    super.dispose();
  }

  Future<void> handleSignUp() async {
    if (controller.isLoading.value) return;

    final message = await controller.signup();

    if (!mounted) return;

    if( message != null) {
       Get.snackbar('Error', message) ;
       return; 
    }
      Get.back();

      Get.snackbar('Success', 'Account created successfully! Please log in.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 30),

                    Container (
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2F3EF),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.account_balance_wallet,
                        size: 34,
                        color: Color(0xFF197866),
                        ),
                      ),
                      
                    ),
                    Text(
                      'Expense Tracker',
                      style: TextStyle(fontSize: 24, color: Color(0xFF197866)),
                      )
                   ],
                ),
              ),
              const SizedBox(height: 40),

              CustomTextFormField(
                hintText: 'Username',
                myController: controller.nameController,
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                hintText: 'Email',
                myController: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outlined,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                hintText: 'Password',
                myController: controller.passwordController,
                isPassword: true,
                prefixIcon: Icons.password_outlined,
              ),
              const SizedBox(height: 20),
              CustomButton(
                color: Color(0xFF197866),
                textColor: Colors.white,
                title: 'Sign Up',
                onPressed: handleSignUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}