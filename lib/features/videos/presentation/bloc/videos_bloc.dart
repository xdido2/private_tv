import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:private_tv/core/network/api_helper.dart';
import 'package:private_tv/features/videos/data/models/video_models.dart';

part 'videos_event.dart';
part 'videos_state.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  VideosBloc() : super(VideosInitial()) {
    on<VideosInitEvent>(videosInitEvent);
  }

  FutureOr<void> videosInitEvent(
    VideosInitEvent event,
    Emitter<VideosState> emit,
  ) async {
    emit(VideosLoadingState());
    if (state is VideosLoadedState) {
      final currentVideos = state as VideosLoadedState;
      if (currentVideos.videos.isNotEmpty) {
        return;
      }
    }
    emit(VideosLoadingState());

    try {
      List<VideoModel> videos = [];

      if (event.onlyPrivate) {
        final response = await AuthHttp.request("/videos/private/");
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as List;
          videos = data.map((e) => VideoModel.fromJson(e)).toList();
        } else {
          emit(
            VideosErrorState("Private videos error: ${response.statusCode}"),
          );
          return;
        }
      } else {
        final response = await AuthHttp.request("/videos/video_list/");
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as List;
          videos = data.map((e) => VideoModel.fromJson(e)).toList();
        } else {
          emit(VideosErrorState("Server error: ${response.statusCode}"));
          return;
        }
      }

      emit(VideosLoadedState(videos: videos));
    } catch (e) {
      emit(VideosErrorState(e.toString()));
    }
  }
}
