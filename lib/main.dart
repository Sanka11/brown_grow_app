import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:brown_grow_app/pages/home.dart'; // Import the Home widget
import 'package:brown_grow_app/pages/signup.dart'; // Import the SignUp page
import 'package:brown_grow_app/pages/admin_dashboard.dart'; // Import Admin Dashboard page
import 'package:brown_grow_app/pages/fieldoffice_dashboard.dart'; // Import Field Officer Dashboard page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brown Grow App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/home', // Set the initial route
      routes: {
        '/home': (context) => const Home(),
        '/signup': (context) => const SignUpPage(),
        '/admin_dashboard': (context) => AdminDashboard(),
        '/field_officer_dashboard': (context) => const FieldOfficerDashboard(),
      },
    );
  }
}
