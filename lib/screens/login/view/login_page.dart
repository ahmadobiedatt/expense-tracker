import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../components/text_form_field.dart';
import '../../../components/custombutton.dart';
import '../controller/login_controller.dart';
import '../../signup/view/signup_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final LoginController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(LoginController());
  }

  @override
  void dispose() {
    Get.delete<LoginController>();
    super.dispose();
  }

  Future<void> handleLogin() async {
    final message = await controller.login();

    if (!mounted || message == null) return;

    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: 'Login Error',
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
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
              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold , color: Color(0xFF197866)),
              ),
              CustomTextFormField(
                hintText: 'Enter your email',
                myController: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline,
              ),
              const SizedBox(height: 30),
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.bold , color: Color(0xFF197866)),
              ),
              CustomTextFormField(
                hintText: 'Enter your password',
                myController: controller.passwordController,
                isPassword: true,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 30),
              CustomButton(
                color: const Color(0xFF197866),
                title: 'Login',
                onPressed: handleLogin,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Obx(
                    () => InkWell(
                      onTap: controller.isLoading.value
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                ),
                              );
                            },
                      child: const Text(
                        ' Register',
                        style: TextStyle(
                          color: Color(0xFF197866),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}