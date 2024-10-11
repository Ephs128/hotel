import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:hotel/data/env.dart';

class LoginApi {
  final storage = const FlutterSecureStorage();

  Future<Data<Login>> postLogin (String user, String password) async {
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/auth/login');
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
    );
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
  }

Future<Data<String>> postLogout (User user) async {
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/auth/logout');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );
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
  }
}