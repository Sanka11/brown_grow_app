import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fieldoffice_dashboard.dart';
import 'package:brown_grow_app/utils/dialog_utils.dart'; // Import the Field Officer Dashboard page

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to handle user signup
  void handleSignUp() async {
    try {
      // Create user using email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Get the UID of the newly created user
      String userUID = userCredential.user?.uid ?? '';

      // Prepare user data to be stored in Firestore
      Map<String, dynamic> userData = {
        'name': nameController.text,
        'email': emailController.text,
        'contact': contactController.text,
        'role': 'field_officer', // Default role for signup
      };

      // Store user data in Firestore under the 'users' collection
      await _firestore.collection('users').doc(userUID).set(userData);

      // Navigate to the field officer dashboard (or any page as needed)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FieldOfficerDashboard()),
      );
      showSuccessDialog(context, "You have successfully registered!");
    } catch (e) {
      // Show error message if signup fails
      print('Signup failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 15.0),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "E-mail Address",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15.0),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: "Contact Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15.0),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: handleSignUp,
                child: const Text("Sign Up"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  textStyle: const TextStyle(fontSize: 18.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: Size(double.infinity, 50), // Full-width button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
