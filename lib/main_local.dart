import 'dart:developer';

import 'package:hotel/env.dart';
import 'package:hotel/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hotel/screens/login_manager.dart';

// ? flutter run -t lib/main_local.dart --flavor local

// ? Build command
// ? flutter build apk --split-per-abi

// ? run from CLI flut
// ? commands
// ? - r Hot reload
// ? - R Hot restart
// ? - d Detach
// ? - q Quit
// ? - c Clear screen
// ? - h list commands

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    log("inicio");
    return MaterialApp(
      theme: happyTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale("es")],
      // debugShowCheckedModeBanner: false,
      home: LoginManager(
        env: Env(
          baseUrl: "http://192.168.0.107:3001",
          appName: "Local host",
          assetsPath: "assets/common"
        ),
      ),
    );
  }

}
