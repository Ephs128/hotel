import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/env.dart';
import 'package:http/http.dart' as http;

class CashboxApi {

  final Env env;

  CashboxApi({required this.env});
  
  Future<Data<List<Cashbox>>> getAllCashboxes() async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/cashboxes/list');
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
            data: listData.map((data) => Cashbox.fromJson(data)).toList(),
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
    }
  }

  Future<Data<String>> createCashbox(String cashboxName, String? amount, String? virtualAmount, String? numberAccount) async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/cashboxes/create');
    try{
      var response = await client.post(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        },
        body: jsonEncode({
          "nombreCaja": cashboxName,
          if (amount != null) "monto": amount,
          if (virtualAmount != null) "montoVirtual": virtualAmount,
          if (numberAccount != null) "numeroCuenta": numberAccount,
        }),
      ).timeout(const Duration(seconds: 10));
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
    } on TimeoutException catch (_) {
      return Data(
        message: "Solicitud cancelada por tiempo de espera. Revisar conexion a internet",
        statusCode: 0,
        data: null
      );
    }
  }

  Future<Data<String>> updateCashbox(Cashbox cashbox) async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/cashboxes/update');
    try{
      var response = await client.put(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        },
        body: jsonEncode(cashbox.toJson()),
      ).timeout(const Duration(seconds: 10));
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
  
  Future<Data<String>> deleteCashbox(Cashbox cashbox) async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/cashboxes/delete/${cashbox.id}');
    var response = await client.delete(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${env.token}',
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