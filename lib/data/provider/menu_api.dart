import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/env.dart';
import 'package:http/http.dart' as http;

class MenuApi{
  
  final Env env;

  MenuApi({required this.env});
  
  Future<Data<List<Menu>>> getAllMenus() async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/menu/list');
    try {
      var response = await client.get(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        }
      ).timeout(const Duration(seconds: 10));
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        List<dynamic> listData = jsonData["data"];
        return Data(
          data: listData.map((data) => Menu.fromJson(data)).toList(),
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