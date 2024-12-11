import 'package:brown_grow_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brown_grow_app/models/user_model.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({Key? key}) : super(key: key);

  @override
  _SideNavBarState createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore using the UserModel
  void _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Get the user data from Firestore based on the user UID
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        // Convert Firestore data to a UserModel instance
        UserModel userModel =
            UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

        // Set the user data in the state
        setState(() {
          userName = userModel.name;
          userRole = userModel.role;
        });
      }
    }
  }

  // Helper function to format the role string (e.g., "field_officer" -> "Field Officer")
  String formatRole(String role) {
    List<String> words = role.split('_');
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i].capitalizeFirstLetter();
    }
    return words.join(' ');
  }

  // Logout function
  void _logout() async {
    try {
      await _auth.signOut(); // Sign out from Firebase
      // Clear navigation stack and navigate to the login page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const Home()), // Replace with your Login page widget
        (route) => false,
      );
    } catch (e) {
      // Handle any errors that occur during sign-out
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header section with user info
          UserAccountsDrawerHeader(
            accountName: Text(userName.isNotEmpty ? userName : 'Loading...'),
            accountEmail:
                Text(userRole.isNotEmpty ? formatRole(userRole) : 'Loading...'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          // Menu items
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home'); // Navigate to home page
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushNamed(
                  context, '/settings'); // Navigate to settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.pushNamed(
                  context, '/profile'); // Navigate to profile page
            },
          ),
          // Logout item
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: _logout, // Trigger logout function
          ),
        ],
      ),
    );
  }
}

// Extension to capitalize the first letter of a string
extension StringCapitalization on String {
  String capitalizeFirstLetter() {
    if (this == null || this.isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
