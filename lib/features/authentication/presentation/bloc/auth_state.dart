// lib/features/authentication/presentation/bloc/auth_state.dart

import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// Auth States - All possible states of authentication
///
/// Think of states as "adjectives" - they describe the CURRENT situation
/// The UI reacts to state changes to show different screens/messages
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

//==============================================================================
// INITIAL STATE
//==============================================================================

/// Initial state when app starts
///
/// Nothing has happened yet
/// UI shows: Splash screen or checking authentication
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  String toString() => 'AuthInitial()';
}

//==============================================================================
// LOADING STATES
//==============================================================================

/// Authentication action in progress
///
/// UI shows: Loading spinner, "Please wait..." message
class AuthLoading extends AuthState {
  final String? message;  // Optional loading message

  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AuthLoading(message: $message)';
}

//==============================================================================
// REGISTRATION STATES
//==============================================================================

/// User successfully registered
///
/// Next step: Request OTP for verification
/// UI shows: "Registration successful! Sending verification code..."
class RegistrationSuccess extends AuthState {
  final User user;
  final String email;  // Need email for OTP request

  const RegistrationSuccess({
    required this.user,
    required this.email,
  });

  @override
  List<Object?> get props => [user, email];

  @override
  String toString() => 'RegistrationSuccess(user: ${user.username})';
}

//==============================================================================
// OTP STATES
//==============================================================================

/// OTP sent successfully
///
/// UI shows: OTP input screen with message "Code sent to your email"
class OTPSent extends AuthState {
  final String email;
  final String message;

  const OTPSent({
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [email, message];

  @override
  String toString() => 'OTPSent(email: $email)';
}

/// OTP verified successfully - User is now authenticated!
///
/// UI shows: Success screen, then navigate to main app
class OTPVerified extends AuthState {
  final User user;
  final String token;

  const OTPVerified({
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [user, token];

  @override
  String toString() => 'OTPVerified(user: ${user.username})';
}

//==============================================================================
// AUTHENTICATED STATE
//==============================================================================

/// User is logged in
///
/// UI shows: Main app (home screen, bookings, etc.)
class Authenticated extends AuthState {
  final User user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];

  @override
  String toString() => 'Authenticated(user: ${user.username})';
}

//==============================================================================
// UNAUTHENTICATED STATE
//==============================================================================

/// User is not logged in
///
/// UI shows: Login/Register screen
class Unauthenticated extends AuthState {
  const Unauthenticated();

  @override
  String toString() => 'Unauthenticated()';
}

//==============================================================================
// ERROR STATE
//==============================================================================

/// An error occurred
///
/// UI shows: Error message, allow user to retry
class AuthError extends AuthState {
  final String message;
  final String? errorCode;  // Optional error code for specific handling

  const AuthError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];

  @override
  String toString() => 'AuthError(message: $message)';
}

//==============================================================================
// SUCCESS STATE
//==============================================================================

/// Generic success state
///
/// Used for successful operations that don't fit other categories
/// UI shows: Success screen with message
class AuthSuccess extends AuthState {
  final String message;
  final User? user;

  const AuthSuccess({
    required this.message,
    this.user,
  });

  @override
  List<Object?> get props => [message, user];

  @override
  String toString() => 'AuthSuccess(message: $message)';
}
//```
//
//**Understanding States:**
//
//Each state represents a "snapshot" of your app at a moment in time:
//```
//App starts → AuthInitial
//User types info → AuthInitial (still initial, just typing)
//User presses Register → AuthLoading (processing...)
//Registration succeeds → RegistrationSuccess (move to OTP)
//OTP sent → OTPSent (show OTP input)
//User enters OTP → AuthLoading (verifying...)
//OTP correct → OTPVerified (logged in!)
//Navigate to app → Authenticated (main app)