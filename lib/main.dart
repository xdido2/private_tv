import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_tv/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:private_tv/features/comments/presentation/bloc/comment_bloc.dart';
import 'package:private_tv/core/network/api_helper.dart';
import 'package:private_tv/features/videos/presentation/bloc/videos_bloc.dart';
import 'package:private_tv/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final authBloc = AuthBloc();
  AuthHttp.onUnauthorized = () => authBloc.add(LogoutEvent());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc..add(AppStarted())),
        BlocProvider<CommentBloc>(create: (_) => CommentBloc()),
        BlocProvider<VideosBloc>(create: (_) => VideosBloc()),
      ],
      child: const PrivateTVApp(),
    ),
  );
}
