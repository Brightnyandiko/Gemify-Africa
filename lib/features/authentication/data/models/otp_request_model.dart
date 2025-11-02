// lib/features/authentication/data/models/otp_request_model.dart

/// OTP Request Model - What we send to request OTP
///
/// POST /request-otp
/// {
///   "email": "john@email.com"
/// }
class OTPRequestModel {
  final String email;

  const OTPRequestModel({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }

  factory OTPRequestModel.fromJson(Map<String, dynamic> json) {
    return OTPRequestModel(
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'OTPRequest(email: $email)';
}