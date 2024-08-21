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

  Future<Data<String>> createCashbox(String cashboxName, String? amount, String? virtualAmount, String? numberAccount) async {
    String token = await storage.read(key: "token") ?? "";
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/cashboxes/create');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "cashboxName": cashboxName,
        if (amount != null) "amount": amount,
        if (virtualAmount != null) "virtualAmount": virtualAmount,
        if (numberAccount != null) "numberAccount": numberAccount,
      }),
    );
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return Data(
        data: jsonData["data"]["message"],
      );
    } else {
      return Data(
        message: jsonData["message"],
        statusCode: jsonData["status"],
        data: null
      );
    }
  }

  Future<Data<String>> updateCashbox(Cashbox cashbox) async {
    String token = await storage.read(key: "token") ?? "";
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/cashboxes/update');
    var response = await client.put(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(cashbox.toJson()),
    );
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return Data(
        data: jsonData["data"]["message"],
      );
    } else {
      return Data(
        message: jsonData["message"],
        statusCode: jsonData["status"],
        data: null
      );
    }
  }
  
  Future<Data<String>> deleteCashbox(Cashbox cashbox) async {
    String token = await storage.read(key: "token") ?? "";
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/cashboxes/delete/${cashbox.id}');
    var response = await client.delete(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return Data(
        data: jsonData["data"]["message"],
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