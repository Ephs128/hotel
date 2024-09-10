import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/device_model.dart';
import 'package:http/http.dart' as http;
import 'package:hotel/data/env.dart';

class DeviceApi {
  final storage = const FlutterSecureStorage();

  Future<Data<List<Device>>> getAllDevices() async {
    String token = await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/devices/list');
    var response = await client.get(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );
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
  } 

  Future<Data<String>> createDevice(String productName, String position, String productCode, String serie, int type, bool automatic, bool pulse) async {
    String token = await storage.read(key: "token") ?? "";
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/devices/create');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
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

  Future<Data<String>> updateDevice(Device device) async {
    String token = await storage.read(key: "token") ?? "";
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/devices/update');
    var response = await client.put(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(device.toJson()),
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

  Future<Data<String>> deleteDevice(Device device) async {
    String token = await storage.read(key: "token") ?? "";
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/devices/delete/${device.id}');
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