part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent(this.username, this.password);
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String password;
  final String password2;
  final String? email;
  final String? avatarPath;

  RegisterEvent({
    required this.username,
    required this.password,
    required this.password2,
    this.email,
    this.avatarPath,
  });
}

class LogoutEvent extends AuthEvent {}
