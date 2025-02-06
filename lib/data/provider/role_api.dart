import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/env.dart';
import 'package:http/http.dart' as http;

class RoleApi {
  
  final Env env;

  RoleApi({required this.env});

  Future<Data<List<Role>>> getAllRoles() async{
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/roles/list');
    try {
      var response = await client.get(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        }
      ).timeout(const Duration(seconds: 10));
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