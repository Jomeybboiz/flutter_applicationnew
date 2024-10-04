import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth/auth_service.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  void register() async {
    final _authService = AuthService();

    if (passwordController.text == confirmpasswordController.text) {
      try {
        await _authService.signUpWithEmailPassword(
          emailController.text,
          passwordController.text,
        );
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registration Successful'),
            content: Text('You can now log in with your credentials.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registration Failed'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Passwords don't match"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
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
          padding: const EdgeInsets.all(20), // Add padding inside the box
          margin: const EdgeInsets.symmetric(
              horizontal: 20), // Add margin to the sides
          decoration: BoxDecoration(
            color: Color.fromARGB(
                255, 244, 244, 244), // Set the background color of the box
            borderRadius: BorderRadius.circular(15), // Rounded edges
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Size based on child content
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_open_rounded,
                size: 144,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),
              Text(
                "Create an account",
                style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold),
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
                    255, 246, 246, 246), // Set to a slightly darker color
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
                    255, 246, 246, 246), // Set to a slightly darker color
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: confirmpasswordController,
                hintText: "Confirm Password",
                obscureText: true,
                hintTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                fillColor: const Color.fromARGB(
                    255, 246, 246, 246), // Set to a slightly darker color
              ),
              const SizedBox(height: 10),
              MyButton(
                text: "Sign Up",
                onTap: register,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: RichText(
                      text: TextSpan(
                        text: "Login here.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          decoration:
                              TextDecoration.underline, // Underline the text
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
