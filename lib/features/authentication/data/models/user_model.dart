// lib/features/authentication/data/models/user_model.dart

import '../../domain/entities/user.dart';

/// User Model - Extends User entity and adds JSON serialization
///
/// This is the "Data Transfer Object" (DTO) that comes from the API
/// It knows how to convert between JSON and our User entity
class UserModel extends User {

  /// Constructor - calls the parent User constructor
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.phone,
    super.createdAt,
    super.updatedAt,
  });

  /// Factory constructor - Creates UserModel from JSON
  ///
  /// What's a factory? It's a constructor that can return different instances
  /// or do logic before creating the object
  ///
  /// Example JSON from your Flask API:
  /// {
  ///   "id": 1,
  ///   "username": "john_doe",
  ///   "email": "john@email.com",
  ///   "phone": "254712345678"
  /// }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Get 'id' from JSON, cast to int
      // If 'id' doesn't exist, this will throw an error
      id: json['id'] as int,

      // Get 'username' from JSON, cast to String
      username: json['username'] as String,

      email: json['email'] as String,

      phone: json['phone'] as String,

      // Optional fields - might not be in the JSON
      // Use null-aware operator ?. to safely access
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert UserModel to JSON for sending to API
  ///
  /// We don't usually send user data back, but this is useful for:
  /// - Local storage
  /// - Debugging
  /// - Profile updates
  @override
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

  /// Convert from Entity to Model
  ///
  /// Why? Sometimes we have a User entity and need to convert it to a model
  /// Example: Saving to local storage
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      phone: user.phone,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  /// Convert Model to Entity
  ///
  /// Why? After getting data from API, we convert to pure entity
  /// This keeps domain layer clean of API concerns
  User toEntity() {
    return User(
      id: id,
      username: username,
      email: email,
      phone: phone,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create a copy with some fields changed
  @override
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}