import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newapp123/pages/adminpage.dart';
import 'package:newapp123/pages/register.dart';
import 'package:newapp123/pages/userPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!mounted) return; //

      if (userDoc.exists) {
        String role = userDoc['role'] ?? 'user';

        if (role == 'admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminPage()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const UserHomePage()),
          );
        }
      } else {
        // Fallback if the user exists in Auth but not in Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not found.")),
        );
      }

      print("Login successful!");
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An error occurred")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(252, 131, 129, 129),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16), // Added some padding
              color: Colors.white,
              height: 480, // Slightly increased height for better fit
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Login Page",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                        "Email:"), // Using email since Firebase Auth uses email
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _emailController, // Link controller
                      decoration:
                          const InputDecoration(hintText: "Enter email"),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Password:"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField( 
                      controller: _passwordController, // Link controller
                      obscureText: true, // Hide password dots
                      decoration:
                          const InputDecoration(hintText: "Enter password"),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: ElevatedButton(
                      // Changed to ElevatedButton for a standard look
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: login, // Call the login function
                      child: const Text("Login"),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegistrationPage(),
                          ),
                        );
                      },
                      child: const Text("New user? Click here to register"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
