import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:private_tv/features/comments/presentation/bloc/comment_bloc.dart';
import 'package:private_tv/features/videos/data/models/video_models.dart';
import 'package:private_tv/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart' as vp;
import 'dart:ui';

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
            materialProgressColors: ChewieProgressColors(
              playedColor: AppColors.primary,
              handleColor: AppColors.primaryContainer,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              bufferedColor: Colors.white.withValues(alpha: 0.5),
            ),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72.h),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 16.w,
                right: 24.w,
                bottom: 16.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
                        onPressed: () => Navigator.of(context).pop(),
                        splashRadius: 24.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'PrivateTV',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              letterSpacing: -1,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Area
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).padding.top + 72.h,
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                width: double.infinity,
                color: Colors.black,
                child: chewieController != null &&
                        videoPlayerController.value.isInitialized
                    ? Chewie(controller: chewieController!)
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            widget.video.preview,
                            fit: BoxFit.cover,
                          ),
                          Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Content Area
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.video.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                          letterSpacing: -0.5,
                        ),
                  ),
                  SizedBox(height: 8.h),

                  // Metadata row
                  Row(
                    children: [
                      Text(
                        '1.2M views', // Hardcoded mockup data
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          '•',
                          style: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.8)),
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(widget.video.createdAt),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Action Buttons Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.thumb_up,
                          label: '42K',
                          isPrimary: true,
                        ),
                        SizedBox(width: 8.w),
                        _buildActionButton(
                          icon: Icons.schedule,
                          label: 'Watch Later',
                        ),
                        SizedBox(width: 8.w),
                        _buildActionButton(
                          icon: Icons.playlist_add,
                          label: 'Playlist',
                        ),
                        SizedBox(width: 8.w),
                        _buildActionButton(
                          icon: Icons.ios_share,
                          label: 'Share',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Description Box
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.description.isNotEmpty
                              ? widget.video.description
                              : 'Dive into the exclusive exploration of architectural silhouettes and the silent narrative of light. This piece explores how darkness defines form in modern brutalist environments. Curated specifically for the PrivateTV Obsidian collection.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onSurfaceVariant.withValues(alpha: 0.9),
                                height: 1.5,
                              ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'SHOW MORE',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Comments Section Widget
                  CommentSection(
                    videoId: widget.video.id,
                    commentCount: widget.video.commentsCount,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, bool isPrimary = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isPrimary ? AppColors.primary : AppColors.onSurfaceVariant,
            size: 18.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: isPrimary ? AppColors.primary : AppColors.onSurfaceVariant,
              fontSize: 12.sp,
              fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
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
                      color: AppColors.surfaceContainerLow,
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
                                    color: AppColors.primary,
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
                                              ) as ImageProvider,
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            comment.userName,
                                            style: TextStyle(
                                              color: AppColors.onSurface,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          Text(
                                            DateFormat(
                                              'MMM dd, yyyy',
                                            ).format(comment.createdAt),
                                            style: TextStyle(
                                              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        comment.text,
                                        style: TextStyle(
                                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                                          fontSize: 13.sp,
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
                                      color: AppColors.error,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                        SafeArea(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest,
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.outlineVariant.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
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
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: textController,
                                    style: TextStyle(
                                      color: AppColors.onSurface,
                                      fontSize: 14.sp,
                                    ),
                                    cursorColor: AppColors.primary,
                                    decoration: InputDecoration(
                                      hintText: 'Add a comment...',
                                      hintStyle: TextStyle(
                                        color: AppColors.onSurfaceVariant.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
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
                                    color: AppColors.primary,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$commentCount Comments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            TextButton.icon(
              onPressed: () => _showComments(context),
              icon: Icon(Icons.sort, color: AppColors.onSurfaceVariant.withValues(alpha: 0.7), size: 18.sp),
              label: Text(
                'Sort',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                  fontSize: 12.sp,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () => _showComments(context),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: const AssetImage("assets/default_avatar.jpg"), // Assume currently logged in user
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 4.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: Text(
                    'Add a comment...',
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
