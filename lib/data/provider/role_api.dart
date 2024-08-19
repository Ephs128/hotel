import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:http/http.dart' as http;
import 'package:hotel/data/env.dart';

class RoleApi {
  final storage = const FlutterSecureStorage();

  Future<Data<List<Role>>> getAllRoles() async{
    String token = await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/roles/list');
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
        data: listData.map((data) => Role.fromJson(data)).toList(),
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