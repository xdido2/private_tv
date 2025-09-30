import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:private_tv/api/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

String parseErrors(dynamic data) {
  if (data == null) return "";

  if (data is String || data is int || data is double || data is bool) {
    return data.toString();
  }

  if (data is List && data.isNotEmpty) {
    return parseErrors(data.first);
  }

  if (data is Map && data.isNotEmpty) {
    final firstEntry = data.entries.first;
    // return "${firstEntry.key}: ${parseErrors(firstEntry.value)}";
    return parseErrors(firstEntry.value);
  }

  return data.toString();
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final access = prefs.getString("access");
    final username = prefs.getString("username");
    final email = prefs.getString("email");
    final avatar = prefs.getString("avatar");

    if (access != null && username != null) {
      emit(AuthAuthenticated(username: username, email: email, avatar: avatar));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      final response = await AuthHttp.login(
        username: event.username,
        password: event.password,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("access", data["access"]);
        await prefs.setString("refresh", data["refresh"]);

        final meResponse = await AuthHttp.request("/users/me/");

        if (meResponse.statusCode == 200) {
          final user = jsonDecode(meResponse.body);
          await prefs.setString("username", user["username"]);
          await prefs.setString("email", user["email"] ?? "");
          await prefs.setString("avatar", user["avatar"] ?? "");
          await prefs.setBool("is_superuser", user["is_superuser"] ?? "");

          emit(
            AuthAuthenticated(
              username: user["username"],
              email: user["email"],
              avatar: user["avatar"],
              isSuperuser: user["is_superuser"],
            ),
          );
        } else {
          emit(
            AuthError(message: "Error retrieving profile", fromRegister: false),
          );
        }
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        emit(
          AuthError(
            message: errorData["detail"] ?? response.statusCode,
            fromRegister: false,
          ),
        );
      }
    } catch (e) {
      emit(AuthError(message: e.toString(), fromRegister: false));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      if (event.password != event.password2) {
        emit(AuthError(message: "Passwords do not match", fromRegister: true));
        return;
      }

      final response = await AuthHttp.register(
        username: event.username,
        password: event.password,
        password2: event.password2,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("access", data["access"]);
        await prefs.setString("refresh", data["refresh"]);
        await prefs.setString("username", data["user"]["username"]);
        await prefs.setString("email", data["user"]["email"] ?? "");
        await prefs.setString("avatar", data["user"]["avatar"] ?? "");
        await prefs.setBool("is_superuser", data["user"]["is_superuser"] ?? "");

        emit(
          AuthAuthenticated(
            username: data["user"]["username"],
            email: data["user"]["email"],
            avatar: data["user"]["avatar"],
            isSuperuser: data["user"]["is_superuser"],
          ),
        );
      } else {
        final dynamic errorData = jsonDecode(response.body);
        final errorMessage = parseErrors(errorData);

        emit(AuthError(message: errorMessage, fromRegister: true));
      }
    } catch (e) {
      emit(AuthError(message: e.toString(), fromRegister: true));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    emit(AuthInitial());
  }
}
