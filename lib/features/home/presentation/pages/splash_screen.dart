import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:private_tv/core/widgets/blur_extension.dart';
import 'package:private_tv/core/theme/app_colors.dart';
import 'package:private_tv/features/auth/presentation/pages/api_auth/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const AuthGate(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient Atmospheric Glow Background
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 300.w,
                    height: 300.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ).blurred(sigma: 100),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 250.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ).blurred(sigma: 80),
                ),
              ],
            ),
          ),

          // Content Overlay
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon Vessel
                        Container(
                          width: 96.w,
                          height: 96.w,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(32.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                offset: const Offset(0, 20),
                                blurRadius: 40,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Glass Shine
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32.r),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.primary.withValues(alpha: 0.1),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.tv,
                                  color: AppColors.primary,
                                  size: 48.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Brand Typography
                        Text(
                          'PrivateTV',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppColors.onSurface,
                                letterSpacing: -1.5,
                              ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'ENCRYPTED ENTERTAINMENT',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 3,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer Identity
                Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Text(
                    'PRIVACY IS OUR PRIMARY CHANNEL',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.outline,
                          fontSize: 10.sp,
                          letterSpacing: 2,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
}
}
