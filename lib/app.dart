import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:private_tv/features/home/presentation/pages/splash_screen.dart';
import 'package:private_tv/core/theme/app_colors.dart';

class PrivateTVApp extends StatelessWidget {
  const PrivateTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 667),
      child: MaterialApp(
        home: const SplashScreen(),
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
          textTheme: GoogleFonts.aleoTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
