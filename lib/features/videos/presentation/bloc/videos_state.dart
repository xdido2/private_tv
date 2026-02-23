part of 'videos_bloc.dart';

@immutable
sealed class VideosState {}

abstract class VideosActionState extends VideosState {}

final class VideosInitial extends VideosState {}

class VideosLoadingState extends VideosState {}

class VideosLoadedState extends VideosState {
  final List<VideoModel> videos;

  VideosLoadedState({required this.videos});
}

class VideosErrorState extends VideosState {
  final String message;

  VideosErrorState(this.message);
}
