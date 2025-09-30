import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_tv/api/auth/bloc/auth_bloc.dart';
import 'package:private_tv/api/videos/bloc/videos_bloc.dart';
import 'package:private_tv/app/pages/auth/api_auth/login_or_register_page.dart';
import 'package:private_tv/app/pages/home_page.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthError,
      listener: (context, state) {
        if (state is AuthError) {
          if (!context.mounted) return;
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.message),
            displayDuration: const Duration(seconds: 10),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            context.read<VideosBloc>().add(VideosInitEvent());

            return const HomePage();
          } else if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthError) {
            return LoginOrRegisterPage(startWithLogin: !state.fromRegister);
          } else {
            return const LoginOrRegisterPage(startWithLogin: true);
          }
        },
      ),
    );
  }
}
