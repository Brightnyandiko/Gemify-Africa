// lib/features/authentication/data/models/register_request_model.dart

/// Register Request Model - What we send to Flask API when registering
///
/// This is what we'll POST to /users endpoint
/// {
///   "username": "john_doe",
///   "email": "john@email.com",
///   "phone": "254712345678"
/// }
class RegisterRequestModel {
  final String username;
  final String email;
  final String phone;

  const RegisterRequestModel({
    required this.username,
    required this.email,
    required this.phone,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
    };
  }

  /// Create from JSON (usually not needed for requests, but useful for testing)
  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  @override
  String toString() {
    return 'RegisterRequest(username: $username, email: $email, phone: $phone)';
  }
}