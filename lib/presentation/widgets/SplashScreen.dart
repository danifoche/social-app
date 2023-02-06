import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app_bloc/settings/app_settings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          splashScreenPath,
          width: 120,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
