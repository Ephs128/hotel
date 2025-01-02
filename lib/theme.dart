import 'package:flutter/material.dart';

ThemeData myTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(35, 42, 60, 1), // Aquí defines el color del AppBar
    foregroundColor: Colors.white, // Color del texto y los iconos del AppBar
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(35, 42, 60, 1), // Aquí defines el color del AppBar
    foregroundColor: Colors.white, // Color del texto y los iconos del AppBar
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 18.0),
  ),
);