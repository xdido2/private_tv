import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:private_tv/api/auth/bloc/auth_bloc.dart';
import 'package:private_tv/app/themes/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: REdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: AppColors.containerColor,
                    title: Text(
                      "Confirm Logout",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    content: Text(
                      "Are you sure you want to log out?",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: AppColors.whiteColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<AuthBloc>().add(LogoutEvent());
                        },
                        child: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.containerColor),
              overlayColor: WidgetStatePropertyAll(
                AppColors.whiteColor.withOpacity(0.1),
              ),
              minimumSize: WidgetStatePropertyAll(Size(double.infinity, 40.h)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            child: Text(
              'Log Out',
              style: TextStyle(color: Colors.red, fontSize: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}
