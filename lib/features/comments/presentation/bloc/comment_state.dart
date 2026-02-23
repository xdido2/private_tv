part of 'comment_bloc.dart';

@immutable
abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoadingState extends CommentState {}

class CommentLoadedState extends CommentState {
  final List<CommentModel> comments;

  CommentLoadedState(this.comments);
}

class CommentErrorState extends CommentState {
  final String message;

  CommentErrorState(this.message);
}
