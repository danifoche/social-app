import 'package:flutter/material.dart';
import 'package:social_app_bloc/presentation/routes/app_router.dart';
import 'package:social_app_bloc/settings/app_settings.dart';
import 'package:social_app_bloc/presentation/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //? Rotta iniziale
  final String _initialRoute = '/home';

  //? Mostra o meno il flag debug
  final bool _showDebugBanner = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: appTheme,
      initialRoute: _initialRoute,
      onGenerateRoute: onGenerateRoute,
      debugShowCheckedModeBanner: _showDebugBanner,
    );
  }
}
