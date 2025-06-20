import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<ContinueAsGuest>(_onContinueAsGuest);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      final user = await _authRepository.getCurrentUser();

      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      // Basic email validation
      if (!_isValidEmail(event.email)) {
        emit(const AuthError(message: 'Please enter a valid email address'));
        return;
      }

      // Basic password validation
      if (event.password.length < 6) {
        emit(const AuthError(message: 'Password must be at least 6 characters'));
        return;
      }

      final user = await _authRepository.signIn(event.email, event.password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());

      // Basic validation
      if (!_isValidEmail(event.email)) {
        emit(const AuthError(message: 'Please enter a valid email address'));
        return;
      }

      if (event.password.length < 6) {
        emit(const AuthError(message: 'Password must be at least 6 characters'));
        return;
      }

      if (event.fullName.trim().isEmpty) {
        emit(const AuthError(message: 'Please enter your full name'));
        return;
      }

      final user = await _authRepository.signUp(
        event.email,
        event.password,
        event.fullName,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      await _authRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.updateUserProfile(event.user);
      emit(AuthAuthenticated(user: event.user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onContinueAsGuest(
    ContinueAsGuest event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthGuest());
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
