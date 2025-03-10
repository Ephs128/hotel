import 'dart:developer';

import 'package:hotel/env.dart';
import 'package:hotel/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hotel/screens/login_manager.dart';

// ? flutter run -t lib/main_local.dart --flavor local

// ? Build command
// ? flutter build apk --split-per-abi
// ? flutter build apk lib/main_kama.dart --split-per-abi --flavor kama

// ? run from CLI flut
// ? commands
// ? - r Hot reload
// ? - R Hot restart
// ? - d Detach
// ? - q Quit
// ? - c Clear screen
// ? - h list commands

// ? shorebird
// ? For information on uploading to the Play Store, see:
// ?   https://support.google.com/googleplay/android-developer/answer/9859152?hl=en
// ?   To create a patch for this release, run:
// ?    > shorebird patch --platforms=android --flavor=kama --target=lib/main_kama.dart --release-version=1.0.0+1
// ?   Note: shorebird patch --platforms=android --flavor=kama --target=lib/main_kama.dart without the --release-version option will patch the current version of the app. 
// ?
// ?   > shorebird preview --app-id _codigo en shorebir yaml_ --release-version 1.0.0+1
// ?   > shorebird release android -t lib/main_kama.dart --flavor kama
// ?   > shorebird release android --artifact apk
// ?  El mas completo
// ?   > shorebird release android -t lib/main_kama.dart --flavor kama --artifact apk

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
          baseUrl: "http://192.168.0.108:3001",
          appName: "Local host",
          assetsPath: "assets/common"
        ),
      ),
    );
  }

}
