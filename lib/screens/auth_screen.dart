import 'package:flutter/material.dart';
import 'package:lakasir/screens/domain/setup_screen.dart';
import 'package:lakasir/screens/login_screen.dart';
import 'package:lakasir/screens/menu_screen.dart';
import 'package:lakasir/screens/onboard_screen.dart';
import 'package:lakasir/utils/auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: checkAuthentication(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == "setup") {
          return const OnboardingScreen();
        } else if (snapshot.data == "login") {
          return const LoginScreen();
        } else {
          return const MenuScreen();
        }
      },
    );
  }
}
