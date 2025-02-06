import 'package:flutter/material.dart';

ThemeData happyTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(185, 187, 193, 1), // Aquí defines el color del AppBar
    foregroundColor: Colors.black, // Color del texto y los iconos del AppBar
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(35, 42, 60, 1), // Aquí defines el color del AppBar
    foregroundColor: Colors.white, // Color del texto y los iconos del AppBar
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 18.0),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
  ),
);

ThemeData kamaTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(0, 0, 0, 1), // Aquí defines el color del AppBar
    foregroundColor: Colors.white, // Color del texto y los iconos del AppBar
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(254, 0, 2, 1), // Aquí defines el color del AppBar
    foregroundColor: Colors.white, // Color del texto y los iconos del AppBar
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 18.0),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
  ),
);