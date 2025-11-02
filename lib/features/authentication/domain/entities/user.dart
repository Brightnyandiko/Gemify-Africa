// lib/features/authentication/domain/entities/user.dart

/// User Entity - Represents a user in our system
/// This is a pure Dart class with no dependencies on Flutter or external packages
class User {
  final int id;                    // Unique identifier from database
  final String username;           // User's chosen username
  final String email;              // User's email address
  final String phone;              // User's phone number
  final DateTime? createdAt;       // When the account was created
  final DateTime? updatedAt;       // When the account was last updated

  /// Constructor - How we create a User object
  /// All fields are required except dates which can be null
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.createdAt,
    this.updatedAt,
  });

  /// Copy with method - Creates a new User with some fields changed
  /// This is immutable programming - we never modify the original object
  /// Example: user.copyWith(username: 'newname') creates a new user with new username
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert User to JSON (for storage)
  /// This allows us to save the user to SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create User from JSON (when reading from storage)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// For debugging - gives us a readable string representation
  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, phone: $phone)';
  }

  /// Equality comparison - Two users are equal if they have the same id
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}