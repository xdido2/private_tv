import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:private_tv/api/comments/models.dart';
import 'package:private_tv/api/helper.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentInitial()) {
    on<LoadCommentsEvent>(_onLoadComments);
    on<AddCommentEvent>(_onAddComment);
  }

  FutureOr<void> _onLoadComments(
    LoadCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoadingState());

    try {
      final response = await AuthHttp.request(
        "/videos/${event.videoId}/comments/",
        authRequired: true,
      );

      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body);
        final comments = result.map((e) => CommentModel.fromJson(e)).toList();

        emit(CommentLoadedState(comments));
      } else {
        emit(CommentErrorState("Server Error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(CommentErrorState(e.toString()));
    }
  }

  FutureOr<void> _onAddComment(
    AddCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoadingState());

    try {
      final response = await AuthHttp.request(
        "/videos/${event.videoId}/comments/",
        method: "POST",
        body: {"author": event.author, "text": event.text},
      );

      if (response.statusCode == 201) {
        add(LoadCommentsEvent(event.videoId));
      } else {
        emit(CommentErrorState("Adding error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(CommentErrorState(e.toString()));
    }
  }
}
