import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:private_tv/api/auth/bloc/auth_bloc.dart';
import 'package:private_tv/app/components/auth_text_field.dart';
import 'package:private_tv/app/themes/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback toggleSwitch;

  const LoginPage({super.key, required this.toggleSwitch});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: REdgeInsets.symmetric(horizontal: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: constraints.maxHeight < 600
                    ? const AlwaysScrollableScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to Private Tv!',
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        Lottie.asset('assets/lottie_files/login_lottie.json'),

                        const Spacer(),

                        AuthTextField(
                          hintText: 'Username',
                          textEditingController: usernameController,
                          isPassword: false,
                        ),
                        SizedBox(height: 10.h),
                        AuthTextField(
                          hintText: 'Password',
                          textEditingController: passwordController,
                          isPassword: true,
                        ),
                        SizedBox(height: 15.h),
                        ElevatedButton(
                          onPressed: () {
                            if (usernameController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              context.read<AuthBloc>().add(
                                LoginEvent(
                                  usernameController.text.trim(),
                                  passwordController.text.trim(),
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
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.whiteColor,
                            ),
                            minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, 40.h),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: AppColors.scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(0.4),
                              ),
                            ),
                            TextButton(
                              onPressed: toggleSwitch,
                              child: Text(
                                'Sign up',
                                style: TextStyle(color: AppColors.whiteColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
