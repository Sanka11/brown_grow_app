class UserModel {
  final String name;
  final String email;
  final String contact;
  final String role;

  UserModel({
    required this.name,
    required this.email,
    required this.contact,
    required this.role,
  });

  // Factory constructor to create UserModel from a map (Firestore data)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      contact: map['contact'] ?? '',
      role: map['role'] ?? 'field_officer', // Default role
    );
  }

  // Method to convert UserModel to map (Firestore saving)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'contact': contact,
      'role': role,
    };
  }
}
