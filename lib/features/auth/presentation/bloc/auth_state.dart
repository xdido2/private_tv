part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String username;
  final String? email;
  final String? avatar;
  final bool? isSuperuser;

  AuthAuthenticated({
    required this.username,
    this.email,
    this.avatar,
    this.isSuperuser,
  });
}

class AuthError extends AuthState {
  final String message;
  final bool fromRegister;

  AuthError({required this.message, required this.fromRegister});
}
