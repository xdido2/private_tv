part of 'videos_bloc.dart';

@immutable
sealed class VideosEvent {}

class VideosInitEvent extends VideosEvent {
  final bool onlyPrivate;

  VideosInitEvent({this.onlyPrivate = false});
}