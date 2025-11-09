// lib/features/authentication/presentation/bloc/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/request_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Auth BLoC - The brain of authentication
///
/// Responsibilities:
/// 1. Receives events (user actions)
/// 2. Calls appropriate use cases (business logic)
/// 3. Emits states (UI updates)
///
/// Think of it as a state machine or a flowchart processor
class AuthBloc extends Bloc<AuthEvent, AuthState> {

  // Dependencies - Use cases that do the actual work
  final RegisterUser registerUser;
  final RequestOTP requestOTP;
  final VerifyOTP verifyOTP;
  final GetCurrentUser getCurrentUser;
  final Logout logout;

  /// Constructor
  ///
  /// Initial state: AuthInitial (nothing has happened yet)
  AuthBloc({
    required this.registerUser,
    required this.requestOTP,
    required this.verifyOTP,
    required this.getCurrentUser,
    required this.logout,
  }) : super(const AuthInitial()) {

    // Register event handlers
    // When event X happens, call handler Y
    on<RegisterUserEvent>(_onRegisterUser);
    on<RequestOTPEvent>(_onRequestOTP);
    on<VerifyOTPEvent>(_onVerifyOTP);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LogoutEvent>(_onLogout);
    on<ResetAuthEvent>(_onResetAuth);
    on<AuthSuccessAcknowledgedEvent>(_onAuthSuccessAcknowledged);
  }

  //============================================================================
  // EVENT HANDLERS
  //============================================================================

  /// Handle user registration
  ///
  /// Flow:
  /// 1. Show loading state
  /// 2. Call registerUser use case
  /// 3. If success: Emit RegistrationSuccess, then automatically request OTP
  /// 4. If error: Emit AuthError
  Future<void> _onRegisterUser(
      RegisterUserEvent event,
      Emitter<AuthState> emit,
      ) async {

    // Step 1: Show loading
    print('🔄 Processing registration for ${event.username}...');
    emit(const AuthLoading(message: 'Creating your account...'));

    // Step 2: Call use case
    final result = await registerUser(
      RegisterUserParams(
        username: event.username,
        email: event.email,
        phone: event.phone,
      ),
    );

    // Step 3: Handle result
    result.fold(
      // Error case (Left side of Either)
          (failure) {
        print('❌ Registration failed: ${failure.message}');
        emit(AuthError(message: failure.message));
      },

      // Success case (Right side of Either)
          (user) async {
        print('✅ Registration successful: ${user.username}');
        emit(RegistrationSuccess(user: user, email: event.email));

        // Automatically request OTP after successful registration
        print('📧 Auto-requesting OTP...');
        await Future.delayed(const Duration(milliseconds: 500));
        add(RequestOTPEvent(email: event.email));
      },
    );
  }

  /// Handle OTP request
  ///
  /// Flow:
  /// 1. Show loading
  /// 2. Call requestOTP use case
  /// 3. Emit OTPSent or AuthError
  Future<void> _onRequestOTP(
      RequestOTPEvent event,
      Emitter<AuthState> emit,
      ) async {

    print('🔄 Requesting OTP for ${event.email}...');
    emit(const AuthLoading(message: 'Sending verification code...'));

    final result = await requestOTP(
      RequestOTPParams(email: event.email),
    );

    result.fold(
          (failure) {
        print('❌ OTP request failed: ${failure.message}');
        emit(AuthError(message: failure.message));
      },
          (message) {
        print('✅ OTP sent successfully');
        emit(OTPSent(
          email: event.email,
          message: message,
        ));
      },
    );
  }

  /// Handle OTP verification
  ///
  /// This is the critical moment - authentication happens here!
  ///
  /// Flow:
  /// 1. Show loading
  /// 2. Call verifyOTP use case
  /// 3. If success: Emit OTPVerified (user is now authenticated!)
  /// 4. If error: Emit AuthError (wrong OTP)
  Future<void> _onVerifyOTP(
      VerifyOTPEvent event,
      Emitter<AuthState> emit,
      ) async {

    print('🔄 Verifying OTP for ${event.email}...');
    emit(const AuthLoading(message: 'Verifying code...'));

    final result = await verifyOTP(
      VerifyOTPParams(
        email: event.email,
        otp: event.otp,
      ),
    );

    result.fold(
          (failure) {
        print('❌ OTP verification failed: ${failure.message}');
        emit(AuthError(message: failure.message));
      },
          (authResponse) {
        print('✅ OTP verified! User authenticated: ${authResponse.user.username}');
        emit(OTPVerified(
          user: authResponse.user,
          token: authResponse.accessToken,
        ));
      },
    );
  }

  /// Check authentication status
  ///
  /// Called when app starts to see if user is already logged in
  ///
  /// Flow:
  /// 1. Call getCurrentUser use case
  /// 2. If user found: Emit Authenticated (skip login screens)
  /// 3. If not found: Emit Unauthenticated (show login screens)
  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event,
      Emitter<AuthState> emit,
      ) async {

    print('🔄 Checking authentication status...');
    emit(const AuthLoading(message: 'Loading...'));

    final result = await getCurrentUser();

    result.fold(
          (failure) {
        print('ℹ️ No authenticated user found');
        emit(const Unauthenticated());
      },
          (user) {
        print('✅ User is authenticated: ${user.username}');
        emit(Authenticated(user: user));
      },
    );
  }

  /// Handle logout
  ///
  /// Flow:
  /// 1. Call logout use case (clears tokens and data)
  /// 2. Emit Unauthenticated (back to login screen)
  Future<void> _onLogout(
      LogoutEvent event,
      Emitter<AuthState> emit,
      ) async {

    print('🔄 Logging out...');
    emit(const AuthLoading(message: 'Logging out...'));

    final result = await logout();

    result.fold(
          (failure) {
        print('❌ Logout failed: ${failure.message}');
        // Even if logout fails, clear state
        emit(const Unauthenticated());
      },
          (_) {
        print('✅ Logged out successfully');
        emit(const Unauthenticated());
      },
    );
  }

  /// Reset authentication state
  ///
  /// Used when navigating back or canceling operations
  void _onResetAuth(
      ResetAuthEvent event,
      Emitter<AuthState> emit,
      ) {
    print('🔄 Resetting auth state...');
    emit(const AuthInitial());
  }

  /// User acknowledged success screen
  ///
  /// Transition from success screen to authenticated state
  void _onAuthSuccessAcknowledged(
      AuthSuccessAcknowledgedEvent event,
      Emitter<AuthState> emit,
      ) {
    print('✅ Success acknowledged, transitioning to authenticated state');

    // Get user from current state if available
    if (state is OTPVerified) {
      final otpState = state as OTPVerified;
      emit(Authenticated(user: otpState.user));
    } else {
      // Fallback - check for current user
      add(const CheckAuthStatusEvent());
    }
  }
}