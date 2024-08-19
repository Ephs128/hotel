import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:hotel/data/env.dart';

class UserApi {
  final storage = const FlutterSecureStorage();

  Future<Data<List<User>>> getAllUsers() async{
    String token = await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/users/list');
    var response = await client.get(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      List<dynamic> listData = jsonData["data"];
      return Data(
        data: listData.map((data) => User.fromJson(data)).toList(),
      );
    } else {
      return Data(
        message: jsonData["message"],
        statusCode: jsonData["status"],
        data: null
      );
    }
  } 
}