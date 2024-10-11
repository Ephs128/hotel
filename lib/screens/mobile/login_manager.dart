import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/screens/mobile/error_view.dart';
import 'package:hotel/screens/mobile/loading_view.dart';
import 'package:hotel/screens/mobile/login_view.dart';
import 'package:hotel/screens/mobile/rooms/rooms_view.dart';
import 'package:hotel/screens/mobile/without_options.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginManager extends StatefulWidget {
  const LoginManager({super.key});

  @override
  State<LoginManager> createState() => _LoginManagerState();
}

class _LoginManagerState extends State<LoginManager> {
  Widget _screen = const LoadingView();
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    // await storage.deleteAll();
    String? token = await storage.read(key: "token");
    String? loginSerialized = await storage.read(key: "login");
    String? menuSerialized = await storage.read(key: "menu");
    
    if (token == null || loginSerialized == null) {
      setState(() {
        _screen = const LoginView();
      });
    } else if (JwtDecoder.isExpired(token)) {
      setState(() {
        _screen = const LoginView(titleMessage: "Sesión expirada", message: "Volver a iniciar sessión",);
      });
    } else {
      Login login = Login.fromJson(jsonDecode(loginSerialized));
      if (menuSerialized == null) {
        setState(() {
          _screen = WithoutOptions(login: login);
        });
      } else {
        Menu menu = Menu.fromJson(jsonDecode(menuSerialized));
        setState(() {
          _screen = RoomsView(login: login, menu: menu);
        });
      }
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return _screen;
  }
}