import 'package:flutter/material.dart';
import 'package:private_tv/app/pages/auth/api_auth/login_page.dart';
import 'package:private_tv/app/pages/auth/api_auth/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  final bool startWithLogin;

  const LoginOrRegisterPage({super.key, this.startWithLogin = true});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  late bool showLoginPage;

  @override
  void initState() {
    super.initState();
    showLoginPage = widget.startWithLogin;
  }

  void toggleSwitch() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(toggleSwitch: toggleSwitch);
    } else {
      return RegisterPage(toggleSwitch: toggleSwitch);
    }
  }
}
