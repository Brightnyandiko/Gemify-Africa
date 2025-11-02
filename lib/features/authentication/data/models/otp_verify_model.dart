// lib/features/authentication/data/models/otp_verify_model.dart

/// OTP Verify Model - What we send to verify OTP
///
/// POST /verify-otp
/// {
///   "email": "john@email.com",
///   "otp": "ABCD12"
/// }
class OTPVerifyModel {
  final String email;
  final String otp;

  const OTPVerifyModel({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }

  factory OTPVerifyModel.fromJson(Map<String, dynamic> json) {
    return OTPVerifyModel(
      email: json['email'] as String,
      otp: json['otp'] as String,
    );
  }

  @override
  String toString() => 'OTPVerify(email: $email, otp: $otp)';
}