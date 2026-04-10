import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:private_tv/core/widgets/logo.dart';
import 'package:private_tv/features/videos/presentation/pages/video_list_page.dart';
import 'package:private_tv/core/services/local_auth_service.dart';
import 'package:private_tv/core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthServices _authService = LocalAuthServices();
  final TextEditingController _pinController = TextEditingController();
  final String _pin = '1234';

  bool _isAuthenticated = false;
  bool _canUseBiometrics = false;
  bool _isPinError = false; // <- флаг для неверного PIN
  String _biometryLabel = 'Use Biometry';

  @override
  void initState() {
    super.initState();
    _initBiometry();
  }

  Future<void> _initBiometry() async {
    final available = await _authService.canCheckBiometrics();
    if (!available) return;

    final biometrics = await LocalAuthentication().getAvailableBiometrics();
    String label = 'Use Biometry';
    if (biometrics.contains(BiometricType.face)) label = 'Use Face ID';
    if (biometrics.contains(BiometricType.fingerprint)) label = 'Use Touch ID';

    setState(() {
      _canUseBiometrics = true;
      _biometryLabel = label;
    });
  }

  void _goHome() {
    if (!mounted || !_isAuthenticated) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        // TODO: Add Is SuperUser condition
        builder: (_) => const VideoListPage(onlyPrivate: false),
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _doBiometricAuth() async {
    final success = await _authService.authenticate();
    if (!mounted) return;
    setState(() {
      _isPinError = false;
      _isAuthenticated = success;
    });
    if (success) _goHome();
  }

  void _doPINAuth(String pin) {
    if (pin == _pin) {
      setState(() {
        _isPinError = false;
        _isAuthenticated = true;
      });
      _goHome();
    } else {
      Future.delayed(
        const Duration(milliseconds: 300),
        () => _pinController.clear(),
      );
      setState(() {
        _isPinError = true;
        _isAuthenticated = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // темы для Pinput, используют флаг _isPinError для цвета рамки
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 60.h,
      textStyle: TextStyle(fontSize: 20.sp, color: AppColors.whiteColor),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: _isPinError
              ? Colors.red
              : AppColors.whiteColor.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: _isPinError ? Colors.red : AppColors.whiteColor,
          width: 2.4,
        ),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: _isPinError
              ? Colors.red
              : AppColors.whiteColor.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Logo(size: 35),
            SizedBox(height: 25.h),
            Container(
              height: 294.h,
              width: 300.w,
              padding: REdgeInsets.fromLTRB(24, 24, 24, 48),
              decoration: BoxDecoration(
                color: AppColors.containerColor,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Authenticate',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  Text(
                    'Enter your 4-digit PIN to continue!',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),

                  // Pinput с контроллером и динамической темой
                  Pinput(
                    controller: _pinController,
                    length: 4,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: false,
                    onCompleted: (pin) => _doPINAuth(pin),
                  ),

                  if (_canUseBiometrics)
                    InkWell(
                      onTap: () {
                        debugPrint('Pressed $_biometryLabel');
                        _doBiometricAuth();
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.person_circle_fill,
                            color: AppColors.whiteColor,
                            size: 30.h,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            _biometryLabel,
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _goHome,
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(252.w, 36.h)),
                      backgroundColor: const WidgetStatePropertyAll(
                        Color.fromRGBO(94, 94, 94, 1),
                      ),
                    ),
                    child: Text(
                      'Proceed to Home',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
