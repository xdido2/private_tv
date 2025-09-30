import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:private_tv/app/themes/app_colors.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.tv_outlined, color: AppColors.whiteColor, size: size.h),
        SizedBox(width: 12),
        Text(
          'PrivateTV',
          style: TextStyle(
            fontSize: (size - 10).sp,
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
