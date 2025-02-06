import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/device_model.dart';
import 'package:hotel/env.dart';
import 'package:http/http.dart' as http;

class DeviceApi {

  final Env env;

  DeviceApi({required this.env});

  Future<Data<List<Device>>> getAllDevices() async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/devices/list');
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
          data: listData.map((data) => Device.fromJson(data)).toList(),
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

  Future<Data<String>> createDevice(String productName, String position, String productCode, String serie, int type, bool automatic, bool pulse) async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/devices/create');
    try {
      var response = await client.post(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        },
        body: jsonEncode({
          "nombreProducto": productName,
          "posicion": position,
          "codigoProducto": productCode,
          "serie": serie,
          "tipo": type,
          "automatico": automatic ? 1 : 0,
          "pulso": pulse ? 1 : 0,
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
    } on SocketException catch (_) {
      return Data(
        message: "Error de red. Revisar la conexion a internet",
        statusCode: 0,
        data: null
      );
    }
  }

  Future<Data<String>> updateDevice(Device device) async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/devices/update');
    try {
      var response = await client.put(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        },
        body: jsonEncode(device.toJson()),
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

}