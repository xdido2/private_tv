import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:private_tv/features/videos/data/models/video_models.dart';
import 'package:private_tv/features/videos/presentation/pages/video_detail_page.dart';
import 'package:private_tv/core/theme/app_colors.dart';

class ContentList extends StatelessWidget {
  final ScrollPhysics physics;
  final List<VideoModel> videos;
  final bool shrinkWrap;

  const ContentList({
    super.key,
    required this.physics,
    required this.videos,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: EdgeInsets.only(
        top: 100.h, // Space for the floating AppBar
        bottom: 120.h, // Space for the floating BottomNavigationBar
        left: 16.w,
        right: 16.w,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoDetailPage(video: videos[index]),
            ),
          ),
          child: Content(video: videos[index]),
        );
      },
    );
  }
}

class Content extends StatelessWidget {
  final VideoModel video;

  const Content({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Thumbnail Area
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      video.preview,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.surfaceContainerHigh,
                          child: Icon(
                            Icons.broken_image,
                            color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                            size: 48.sp,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Meta Data Area
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        height: 1.2,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  video.description.isNotEmpty
                      ? video.description
                      : 'Experience the raw power and untamed beauty of the world\'s deepest blue horizons.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
