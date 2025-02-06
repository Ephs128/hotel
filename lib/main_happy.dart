import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hotel/env.dart';
import 'package:hotel/screens/login_manager.dart';
import 'package:hotel/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: happyTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale("es")],
      debugShowCheckedModeBanner: false,
      home: LoginManager(
        env: Env(
          baseUrl: "https://happy.smartbsolutions.com",
          appName: "Happy Hour",
          assetsPath: "assets/happy"
        ),
      ),
    );
  }

}