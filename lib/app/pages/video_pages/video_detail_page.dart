import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:private_tv/api/comments/bloc/comment_bloc.dart';
import 'package:private_tv/api/videos/models.dart';
import 'package:private_tv/app/components/content_list.dart';
import 'package:private_tv/app/themes/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart' as vp;

class VideoDetailPage extends StatefulWidget {
  final VideoModel video;

  const VideoDetailPage({super.key, required this.video});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late vp.VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = vp.VideoPlayerController.networkUrl(
      Uri.parse(widget.video.video),
    );
    videoPlayerController.initialize().then((_) {
      if (mounted) {
        setState(() {
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            autoPlay: false,
            looping: false,
            aspectRatio: videoPlayerController.value.aspectRatio,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (chewieController != null && videoPlayerController.value.isInitialized) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                VideoPlayerWidget(
                  videoPlayerController: videoPlayerController,
                  chewieController: chewieController,
                ),
                SizedBox(height: 15.h),
                VideoInfoSection(videoModel: widget.video),
                SizedBox(height: 10.h),
                CommentSection(
                  videoId: widget.video.id,
                  commentCount: widget.video.commentsCount,
                ),
                ContentList(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  videos: [],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: AppColors.scaffoldBackgroundColor,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.whiteColor),
        ),
      );
    }
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final vp.VideoPlayerController videoPlayerController;
  final ChewieController? chewieController;

  const VideoPlayerWidget({
    super.key,
    required this.videoPlayerController,
    required this.chewieController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: videoPlayerController.value.aspectRatio,
        child: Center(child: Chewie(controller: chewieController!)),
      ),
    );
  }
}

class VideoInfoSection extends StatefulWidget {
  final VideoModel videoModel;

  const VideoInfoSection({super.key, required this.videoModel});

  @override
  State<VideoInfoSection> createState() => _VideoInfoSectionState();
}

class _VideoInfoSectionState extends State<VideoInfoSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy').format(widget.videoModel.createdAt);
    return Container(
      width: double.infinity,
      margin: REdgeInsets.symmetric(horizontal: 10),
      padding: REdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.videoModel.title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor,
            ),
          ),
          SizedBox(height: 5.h),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: AnimatedCrossFade(
              firstChild: Text(
                '$date ● ${widget.videoModel.description}',
                style: TextStyle(fontSize: 16.sp, color: AppColors.whiteColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                widget.videoModel.description,
                style: TextStyle(fontSize: 16.sp, color: AppColors.whiteColor),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentSection extends StatelessWidget {
  final String videoId;
  final int commentCount;

  const CommentSection({
    super.key,
    required this.videoId,
    required this.commentCount,
  });

  Future<String?> _getUserAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("avatar");
  }

  void _showComments(BuildContext context) async {
    context.read<CommentBloc>().add(LoadCommentsEvent(videoId));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bloc = context.read<CommentBloc>();
        final textController = TextEditingController();
        return FutureBuilder(
          future: _getUserAvatar(),
          builder: (context, snapshot) {
            final avatarUrl = snapshot.data;
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.7,
                minChildSize: 0.4,
                maxChildSize: 0.95,
                builder: (_, controller) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.containerColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<CommentBloc, CommentState>(
                            builder: (context, state) {
                              if (state is CommentLoadingState) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.whiteColor,
                                  ),
                                );
                              } else if (state is CommentLoadedState) {
                                return ListView.builder(
                                  controller: controller,
                                  itemCount: state.comments.length,
                                  itemBuilder: (_, i) {
                                    final comment = state.comments[i];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            comment.userAvatar != null
                                            ? NetworkImage(comment.userAvatar!)
                                            : const AssetImage(
                                                "assets/default_avatar.jpg",
                                              ),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            comment.userName,
                                            style: TextStyle(
                                              color: AppColors.whiteColor,
                                            ),
                                          ),
                                          Text(
                                            DateFormat(
                                              'dd MMM yyyy',
                                            ).format(comment.createdAt),
                                            style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        comment.text,
                                        style: TextStyle(
                                          color: AppColors.whiteColor
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (state is CommentErrorState) {
                                return Center(
                                  child: Text(
                                    state.message,
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage:
                                      avatarUrl != null && avatarUrl.isNotEmpty
                                      ? NetworkImage(avatarUrl)
                                      : const AssetImage(
                                              "assets/default_avatar.jpg",
                                            )
                                            as ImageProvider,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: textController,
                                    style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 14,
                                    ),
                                    cursorColor: AppColors.whiteColor,
                                    decoration: InputDecoration(
                                      hintText: 'Add a comment...',
                                      hintStyle: TextStyle(
                                        color: AppColors.whiteColor.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    final text = textController.text.trim();
                                    if (text.isNotEmpty) {
                                      bloc.add(
                                        AddCommentEvent(
                                          videoId: videoId,
                                          author: "Me",
                                          text: text,
                                        ),
                                      );
                                      textController.clear();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showComments(context),
      child: Container(
        margin: REdgeInsets.symmetric(horizontal: 10),
        padding: REdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.containerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.comment, color: AppColors.whiteColor, size: 20.sp),
            SizedBox(width: 13.w),
            Text(
              'Comments ($commentCount)',
              style: TextStyle(color: AppColors.whiteColor, fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
