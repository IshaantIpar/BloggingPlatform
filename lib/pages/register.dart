import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newapp123/pages/login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // 1. Controllers to grab input data
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. Registration Logic
  Future<void> register() async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Save additional details (Name & Username) to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'fullName': _nameController.text.trim(),
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'user', // Default role as per your doc
      });

      // Success! Navigate to login or home
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(252, 131, 129, 129),
      body: SingleChildScrollView(
        // Added to prevent overflow on keyboard popup
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  width: 350,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Registration",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Full Name Field
                      const Text("Full Name:"),
                      TextField(controller: _nameController),
                      const SizedBox(height: 15),

                      // Email Field
                      const Text("Email:"),
                      TextField(controller: _emailController),
                      const SizedBox(height: 15),

                      // Username Field
                      const Text("Username:"),
                      TextField(
                        controller: _usernameController,
                      ),
                      const SizedBox(height: 15),

                      // Password Field
                      const Text("Password:"),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),

                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(150, 50),
                          ),
                          onPressed: register,
                          child: const Text("Register"),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Go back to login
                          },
                          child:
                              const Text("Already have an account? Click here"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
