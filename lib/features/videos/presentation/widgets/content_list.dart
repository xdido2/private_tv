import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemBuilder: (context, index) => InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoDetailPage(video: videos[index]),
          ),
        ),
        child: Content(video: videos[index]),
      ),
      separatorBuilder: (context, index) => SizedBox(height: 15),
      itemCount: videos.length,

      padding: REdgeInsets.all(15),
    );
  }
}

class Content extends StatelessWidget {
  final VideoModel video;

  const Content({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: REdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.network(video.preview),
          ),
          SizedBox(height: 10.h),
          Text(
            video.title,
            style: TextStyle(fontSize: 16.sp, color: AppColors.whiteColor),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy').format(video.createdAt),
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
