import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:private_tv/core/widgets/blur_extension.dart';
import 'package:private_tv/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:private_tv/core/theme/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


class LoginPage extends StatefulWidget {
  final VoidCallback toggleSwitch;

  const LoginPage({super.key, required this.toggleSwitch});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      context.read<AuthBloc>().add(
        LoginEvent(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        ),
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Enter Login and Password",
        ),
        displayDuration: const Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Atmospheric Background Elements
          Positioned(
            top: -100.h,
            left: -50.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ).blurred(sigma: 120),
          ),
          Positioned(
            bottom: -100.h,
            right: -50.w,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ).blurred(sigma: 150),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 48.h),
                        // Logo Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock, color: AppColors.primary, size: 24.sp),
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
                        SizedBox(height: 48.h),

                        // Welcome Text
                        Text(
                          'Welcome Back',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                                letterSpacing: -1,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Enter your credentials to access your private vault.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32.h),

                        // Form
                        // Username Field
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
                            child: Text(
                              'USERNAME',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.5,
                                  ),
                            ),
                          ),
                        ),
                        Container(
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: TextField(
                            controller: _usernameController,
                            style: TextStyle(color: AppColors.onSurface),
                            decoration: InputDecoration(
                              hintText: 'name@vault.com',
                              hintStyle: TextStyle(
                                color: AppColors.outline.withValues(alpha: 0.4),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Password Field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Text(
                                'PASSWORD',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.5,
                                    ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'FORGOT KEY?',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            style: TextStyle(color: AppColors.onSurface),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: TextStyle(
                                color: AppColors.outline.withValues(alpha: 0.4),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                  color: AppColors.outline.withValues(alpha: 0.6),
                                  size: 20.sp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Login Button
                        Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryContainer],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                offset: const Offset(0, 12),
                                blurRadius: 24,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              'Unlock Access',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: const Color(0xFF1A0063), // onPrimaryFixedVariant
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),

                        // Secondary Action
                        SizedBox(height: 48.h),
                        Divider(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
                        SizedBox(height: 32.h),
                        Text(
                          'New to the platform?',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: widget.toggleSwitch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surfaceContainerHigh,
                            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Request Invite',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),

                        const Spacer(),

                        // Footer
                        Padding(
                          padding: EdgeInsets.only(bottom: 32.h, top: 16.h),
                          child: Text(
                            'ENCRYPTED CONNECTION • 256-BIT SECURITY',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.outline.withValues(alpha: 0.4),
                                  fontSize: 10.sp,
                                  letterSpacing: 2,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
