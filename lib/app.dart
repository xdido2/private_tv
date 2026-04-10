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
      designSize: const Size(375, 812), // Update design size for modern phones
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          home: const SplashScreen(),
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.background,
              onSurface: AppColors.onSurface,
            ),
            textTheme: GoogleFonts.interTextTheme(
              ThemeData.dark().textTheme,
            ).copyWith(
              displayLarge: GoogleFonts.manrope(
                textStyle: ThemeData.dark().textTheme.displayLarge,
              ),
              displayMedium: GoogleFonts.manrope(
                textStyle: ThemeData.dark().textTheme.displayMedium,
              ),
              displaySmall: GoogleFonts.manrope(
                textStyle: ThemeData.dark().textTheme.displaySmall,
              ),
              headlineLarge: GoogleFonts.manrope(
                textStyle: ThemeData.dark().textTheme.headlineLarge,
              ),
              headlineMedium: GoogleFonts.manrope(
                textStyle: ThemeData.dark().textTheme.headlineMedium,
              ),
              headlineSmall: GoogleFonts.manrope(
                textStyle: ThemeData.dark().textTheme.headlineSmall,
              ),
              titleLarge: GoogleFonts.manrope(
                textStyle: ThemeData.dark().textTheme.titleLarge,
              ),
              titleMedium: GoogleFonts.manrope(
                textStyle: ThemeData.dark().textTheme.titleMedium,
              ),
              titleSmall: GoogleFonts.manrope(
                textStyle: ThemeData.dark().textTheme.titleSmall,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
