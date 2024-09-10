import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/data.dart';
import 'package:http/http.dart' as http;
import 'package:hotel/data/env.dart';

class LoginApi {
  final storage = const FlutterSecureStorage();

  Future<Data<String>> postLogin (String user, String password) async {
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
      String token = postResult["data"]["token"];
      await storage.write( 
        key: "token",
        value: token,
      );
      return Data(
        data: token,
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