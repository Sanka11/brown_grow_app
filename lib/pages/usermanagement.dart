import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brown_grow_app/models/user_model.dart';

class UserManagement extends StatefulWidget {
  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserModel> _users = [];
  bool _isLoading = true;
  String _searchQuery = "";
  String _selectedRole = "All"; // Default value for the role filter

  // Map for translating user-friendly roles to Firestore roles
  final Map<String, String> roleMap = {
    'All': '',
    'Admin': 'admin',
    'Field Officer': 'field_officer',
  };

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Fetch user data from Firestore
  void _fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      List<UserModel> usersList = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      setState(() {
        _users = usersList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching users: $e")),
      );
    }
  }

  // Filter users based on search query and selected role
  List<UserModel> _filterAndSortUsers() {
    List<UserModel> filteredUsers = _users;

    // First, filter users based on search query (name/email)
    filteredUsers = filteredUsers.where((user) {
      return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Filter by role if not "All"
    if (_selectedRole != "All") {
      String firestoreRole =
          roleMap[_selectedRole]!; // Get Firestore role from map
      filteredUsers = filteredUsers
          .where((user) => user.role.toLowerCase() == firestoreRole)
          .toList();
    }

    return filteredUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        actions: [
          // Dropdown menu to sort by role
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedRole = value;
              });
            },
            itemBuilder: (context) {
              return ['All', 'Admin', 'Field Officer']
                  .map((role) => PopupMenuItem<String>(
                        value: role,
                        child: Text(role),
                      ))
                  .toList();
            },
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                labelText: "Search Users",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            const SizedBox(height: 20),

            // If loading, show the CircularProgressIndicator
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator())),
            // Otherwise, display the user list
            if (!_isLoading) ...[
              _filterAndSortUsers().isEmpty
                  ? const Expanded(
                      child: Center(child: Text("No users found")),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _filterAndSortUsers().length,
                        itemBuilder: (context, index) {
                          UserModel user = _filterAndSortUsers()[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 4.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(user.name[0].toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              title: Text(user.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Email: ${user.email}'),
                                  Text('Contact: ${user.contact}'),
                                  Text('Role: ${user.role}'),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  // Action for more options (Edit/Delete)
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ],
        ),
      ),
    );
  }
}
