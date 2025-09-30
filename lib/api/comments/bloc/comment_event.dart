part of 'comment_bloc.dart';

@immutable
abstract class CommentEvent {}

class LoadCommentsEvent extends CommentEvent {
  final String videoId;

  LoadCommentsEvent(this.videoId);
}

class AddCommentEvent extends CommentEvent {
  final String videoId;
  final String author;
  final String text;

  AddCommentEvent({
    required this.videoId,
    required this.author,
    required this.text,
  });
}
