import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/env.dart';
import 'package:hotel/screens/error_view.dart';
import 'package:hotel/screens/loading_view.dart';
import 'package:hotel/screens/login_view.dart';
import 'package:hotel/screens/rooms/rooms_view.dart';
import 'package:hotel/screens/without_options.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginManager extends StatefulWidget {
  
  final Env env;
  
  const LoginManager({
    super.key,
    required this.env,
  });

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
        _screen = LoginView(env: widget.env);
      });
    } else if (JwtDecoder.isExpired(token)) {
      setState(() {
        _screen = LoginView(env: widget.env, titleMessage: "Sesión expirada", message: "Volver a iniciar sessión",);
      });
    } else {
      widget.env.token = token;
      Login login = Login.fromJson(jsonDecode(loginSerialized));
      if (menuSerialized == null) {
        log("no tiene menu");
        setState(() {
          _screen = WithoutOptions(env: widget.env, login: login);
        });
      } else {
        log("supuestamente bien");
        Menu menu = Menu.fromJson(jsonDecode(menuSerialized));
        setState(() {
          _screen = RoomsView(env: widget.env, login: login, menu: menu);
        });
      }
    }
  
  }

  @override
  Widget build(BuildContext context) {
    return _screen;
  }
}