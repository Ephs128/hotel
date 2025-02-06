import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/env.dart';
import 'package:http/http.dart' as http;

class LoginApi {

  final storage = const FlutterSecureStorage();
  final Env env;

  LoginApi({required this.env});

  Future<Data<Login>> postLogin (String user, String password) async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/auth/login');
    try {
      var response = await client.post(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "usuario": user,
          "contrasenia": password
        }),
      ).timeout(const Duration(seconds: 10));
      final postResult = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        Login login = Login.fromJson(postResult["data"]);
        await storage.write( 
          key: "token",
          value: login.token,
        );
        await storage.write(
          key: "login",
          value: jsonEncode(login.toJson()),
        );
        env.token = login.token;
        return Data(
          data: login,
        );
      } else {
        return Data(
          message: postResult["message"],
          statusCode: postResult["status"],
          data: null
        );
      }
    } on TimeoutException catch (_) {
      return Data(
        message: "Solicitud cancelada por tiempo de espera. Revisar conexion a internet",
        statusCode: 0,
        data: null
      );
    } on SocketException catch (_) {
      return Data(
        message: "Error de red. Revisar la conexion a internet",
        statusCode: 0,
        data: null
      );
    }
  }

Future<Data<String>> postLogout (User user) async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/auth/logout');
    try {
      var response = await client.post(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      ).timeout(const Duration(seconds: 10));
      final postResult = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        String result = postResult["data"]["message"];
        await storage.deleteAll();
        return Data(
          data: result,
        );
      } else {
        return Data(
          message: postResult["message"],
          statusCode: postResult["status"],
          data: null
        );
      }
    } on TimeoutException catch (_) {
      return Data(
        message: "Solicitud cancelada por tiempo de espera. Revisar conexion a internet",
        statusCode: 0,
        data: null
      );
    } on SocketException catch (_) {
      return Data(
        message: "Error de red. Revisar la conexion a internet",
        statusCode: 0,
        data: null
      );
    }
  }
}