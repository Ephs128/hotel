import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/cashbox_model.dart';
import 'package:http/http.dart' as http;
import 'package:hotel/data/env.dart';

class CashboxApi {
  final storage = const FlutterSecureStorage();

  Future<Data<List<Cashbox>>> getAllCashboxes() async {
    String token = await storage.read(key: "token") ?? "";
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/cashboxes/list');
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
        data: listData.map((data) => Cashbox.fromJson(data)).toList(),
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