import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/branchespage.dart';
import 'package:flutter_application_1/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is authenticated, show the app
            return PepinosInventoryApp(); // Your main app
          } else {
            // User is not authenticated, show the login/register screen
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}

class PepinosInventoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pepino\'s Inventory System',
      theme: ThemeData(
        primarySwatch: Colors.green, // Set your desired theme color
      ),
      home: BranchesPage(), // Start with the BranchesPage
    );
  }
}