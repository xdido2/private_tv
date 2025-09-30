import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:private_tv/app/themes/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final bool isPassword;
  final String hintText;
  final TextEditingController textEditingController;

  const AuthTextField({
    super.key,
    required this.hintText,
    required this.textEditingController,
    required this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      controller: textEditingController,
      style: TextStyle(color: AppColors.whiteColor, fontSize: 16.sp),
      cursorColor: AppColors.whiteColor,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.whiteColor.withOpacity(0.5)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: AppColors.whiteColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
