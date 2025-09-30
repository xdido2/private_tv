import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:private_tv/api/auth/bloc/auth_bloc.dart';
import 'package:private_tv/api/comments/bloc/comment_bloc.dart';
import 'package:private_tv/api/helper.dart';
import 'package:private_tv/api/videos/bloc/videos_bloc.dart';
import 'package:private_tv/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final authBloc = AuthBloc();
  AuthHttp.authBloc = authBloc;

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
