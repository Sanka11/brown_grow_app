import 'package:flutter/material.dart';
import 'package:brown_grow_app/widgets/side_nav_bar.dart'; // Import the SideNavBar widget

class FieldOfficerDashboard extends StatelessWidget {
  const FieldOfficerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Field Officer Dashboard"),
      ),
      // Add Drawer (SideNavBar) to the Scaffold
      drawer: const SideNavBar(), // Add the SideNavBar here
      body: const Center(
        child: Text("Welcome, Field Officer!"),
      ),
    );
  }
}
