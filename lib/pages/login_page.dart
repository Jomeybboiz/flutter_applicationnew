import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_textfield.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isInputFilled = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to both controllers to track input changes
    emailController.addListener(_checkInput);
    passwordController.addListener(_checkInput);
  }

  // Check if both email and password fields have input
  void _checkInput() {
    setState(() {
      _isInputFilled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // login method
  void login() async {
    final _authService = AuthService();
    try {
      await _authService.signInWithEmailPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 244, 244, 244),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_pizza,
                size: 144,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),
              Text(
                "Pepino's Pizza",
                style: TextStyle(
                  fontSize: 42,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Inventory Management Application",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
                hintTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                fillColor: const Color.fromARGB(
                    255, 246, 246, 246), // Use darker fill color
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
                hintTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                fillColor: const Color.fromARGB(
                    255, 246, 246, 246), // Use darker fill color
              ),
              const SizedBox(height: 10),
              MyButton(
                text: "Log In",
                onTap: _isInputFilled
                    ? login
                    : null, // Disable button when no input
                buttonColor: _isInputFilled
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Color.fromARGB(255, 223, 223,
                        223), // Change button color based on input
                textColor: _isInputFilled
                    ? Theme.of(context).colorScheme.primary
                    : Color.fromARGB(
                        255, 193, 193, 193), // Change text color based on input
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 4),
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Register here.",
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
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
