import 'package:brown_grow_app/pages/usermanagement.dart';
import 'package:flutter/material.dart';
import 'package:brown_grow_app/widgets/side_nav_bar.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const SideNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Admin Dashboard",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            // Displaying the buttons in a GridView
            GridView.count(
              shrinkWrap:
                  true, // To prevent the GridView from taking too much space
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 16, // Spacing between columns
              mainAxisSpacing: 16, // Spacing between rows
              children: [
                _buildDashboardButton(context, "User Management", Icons.people,
                    () {
                  //navigation logic here
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserManagement()),
                  );
                }),
                _buildDashboardButton(
                    context, "Product Management", Icons.shopping_cart, () {
                  // Add navigation logic here
                }),
                _buildDashboardButton(
                    context, "Maintenance Details", Icons.build, () {
                  // Add navigation logic here
                }),
                _buildDashboardButton(
                    context, "Inventory Details", Icons.inventory, () {
                  // Add navigation logic here
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // A helper function to build buttons
  Widget _buildDashboardButton(
      BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4.0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.blueAccent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40.0,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
