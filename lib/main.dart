import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hotel/screens/desktop/login_screen.dart';
import 'package:hotel/screens/mobile/login_manager.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).platform == TargetPlatform.android) {
      return const MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [Locale("es")],
        debugShowCheckedModeBanner: false,
        home: LoginManager(),
      );
    } else {
      return const FluentApp(
        // theme: FluentThemeData(scaffoldBackgroundColor: Colors.grey[50]),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [Locale("es")],
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      );
    }
  }
}
