import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:private_tv/features/videos/presentation/bloc/videos_bloc.dart';
import 'package:private_tv/features/videos/presentation/widgets/content_list.dart';
import 'package:private_tv/core/theme/app_colors.dart';

class VideoListPage extends StatelessWidget {
  final bool onlyPrivate;

  const VideoListPage({super.key, this.onlyPrivate = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideosBloc, VideosState>(
      builder: (context, state) {
        if (state is VideosLoadingState || state is VideosInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is VideosLoadedState) {
          return RefreshIndicator(
            color: AppColors.whiteColor,
            backgroundColor: Colors.transparent,
            onRefresh: () async {
              context.read<VideosBloc>().add(
                VideosInitEvent(onlyPrivate: onlyPrivate),
              );
            },
            child: ContentList(
              videos: state.videos,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
          );
        } else if (state is VideosErrorState) {
          return RefreshIndicator(
            color: AppColors.whiteColor,
            backgroundColor: Colors.transparent,
            onRefresh: () async {
              context.read<VideosBloc>().add(
                VideosInitEvent(onlyPrivate: onlyPrivate),
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: SizedBox(
                    width: 400.w,
                    height: 400.h,
                    child: Lottie.asset(
                      'assets/lottie_files/network_error_lottie.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
