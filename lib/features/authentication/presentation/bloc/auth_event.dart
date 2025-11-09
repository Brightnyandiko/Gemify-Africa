// lib/features/authentication/presentation/bloc/auth_event.dart

import 'package:equatable/equatable.dart';

/// Auth Events - All possible user actions in authentication
///
/// Think of these as "verbs" - things the user can DO
/// Each event represents a user action or system trigger
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

//==============================================================================
// REGISTER EVENTS
//==============================================================================

/// User wants to register a new account
///
/// Triggered when: User fills registration form and presses "Sign Up"
class RegisterUserEvent extends AuthEvent {
  final String username;
  final String email;
  final String phone;

  const RegisterUserEvent({
    required this.username,
    required this.email,
    required this.phone,
  });

  /// props - Used by Equatable to compare events
  /// Two events are equal if all fields match
  @override
  List<Object?> get props => [username, email, phone];

  @override
  String toString() => 'RegisterUserEvent(username: $username, email: $email)';
}

//==============================================================================
// OTP EVENTS
//==============================================================================

/// User wants to request OTP
///
/// Triggered when:
/// - After successful registration
/// - User presses "Resend OTP"
class RequestOTPEvent extends AuthEvent {
  final String email;

  const RequestOTPEvent({required this.email});

  @override
  List<Object?> get props => [email];

  @override
  String toString() => 'RequestOTPEvent(email: $email)';
}

/// User wants to verify OTP
///
/// Triggered when: User enters 6-digit OTP and presses "Verify"
class VerifyOTPEvent extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOTPEvent({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];

  @override
  String toString() => 'VerifyOTPEvent(email: $email, otp: $otp)';
}

//==============================================================================
// SESSION EVENTS
//==============================================================================

/// Check if user is already logged in
///
/// Triggered when: App starts
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();

  @override
  String toString() => 'CheckAuthStatusEvent()';
}

/// User wants to log out
///
/// Triggered when: User presses "Logout" button
class LogoutEvent extends AuthEvent {
  const LogoutEvent();

  @override
  String toString() => 'LogoutEvent()';
}

//==============================================================================
// NAVIGATION EVENTS
//==============================================================================

/// Reset authentication state
///
/// Triggered when: User wants to start fresh (e.g., navigate back)
class ResetAuthEvent extends AuthEvent {
  const ResetAuthEvent();

  @override
  String toString() => 'ResetAuthEvent()';
}

/// User acknowledged success and wants to continue
///
/// Triggered when: User presses "Continue" on success screen
class AuthSuccessAcknowledgedEvent extends AuthEvent {
  const AuthSuccessAcknowledgedEvent();

  @override
  String toString() => 'AuthSuccessAcknowledgedEvent()';
}