import 'package:equatable/equatable.dart';

import '../../../data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object?> get props => [email, password, fullName];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class UpdateUserProfile extends AuthEvent {
  final UserModel user;

  const UpdateUserProfile({required this.user});

  @override
  List<Object?> get props => [user];
}

class ContinueAsGuest extends AuthEvent {
  const ContinueAsGuest();
}