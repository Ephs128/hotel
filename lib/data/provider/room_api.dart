import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/product_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/models/room_state_model.dart';
import 'package:hotel/data/models/user_model.dart';

import 'package:http/http.dart' as http;
import 'package:hotel/data/env.dart';
import 'package:intl/intl.dart';
class RoomApi {

  final storage = const FlutterSecureStorage();
  final DateFormat _timeFormat = DateFormat("HH:mm");
  String? _token;

  Future<Data<List<Room>>> getAllRooms() async {
    _token ??= await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/rooms/list');
    var response = await client.get(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      }
    );
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      List<dynamic> listData = jsonData["data"];
      return Data(
        data: listData.map((data) => Room.fromJson(data)).toList(),
      );
    } else {
      return Data(
        message: jsonData["message"],
        statusCode: jsonData["status"],
        data: null
      );
    }
  }

  Future<Data<String>> enableRoom(Room room) async {
    _token ??= await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    room.product.time = DateTime.now();
    room.product.actualTime = _timeFormat.format(room.product.time!);
    var uri = Uri.parse('$baseURL/api/v1/rooms/enable');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(room.toJson()),
    );
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
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

  Future<Data<String>> cleanRoom(Room room, int activate, User? user) async {
    int oldval = room.product.activate;
    room.product.activate = activate;
    _token ??= await storage.read(key: "token") ?? "wtf?";
    Map<String, dynamic> body = room.toJson();
    if (user != null) body["limpieza"] = user.user;

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/rooms/clean');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(body),
    );
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    log("respuesta de peticion clean");
    log(jsonData.toString());
    if (response.statusCode == 200) {
      return Data(
        data: jsonData["data"]["message"],
      );
    } else {
      room.product.activate = oldval;
      return Data(
        message: jsonData["message"],
        statusCode: jsonData["status"],
        data: null
      );
    }
  }

  Future<Data<String>> dispRoom(Product product, int activate) async {
    _token ??= await storage.read(key: "token") ?? "wtf?";
    
    int oldval = product.activate;
    product.activate = activate;

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/rooms/disp');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(product.toJson()),
    );
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      return Data(
        data: jsonData["data"]["message"],
      );
    } else {
      product.activate = oldval;
      return Data(
        message: jsonData["message"],
        statusCode: jsonData["status"],
        data: null
      );
    }
  }

  Future<Data<String>> changeRoom(Room room1, Room room2) async {
    _token ??= await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/rooms/change');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        "habitacion1": room1.toJson(),
        "habitacion2": room2.toJson()
      }),
    );
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
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

  _format(Duration d) => d.toString().split('.').first.padLeft(5, "0");

  Future<Data<String>> cancelRoom(Room room) async {
    _token ??= await storage.read(key: "token") ?? "wtf?";
    Duration elapsedTime = DateTime.now().difference(room.product.time!);
    room.product.actualTime = _format(elapsedTime);
    log(room.toJson().toString());
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/rooms/cancel');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(room.toJson()),
    );
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
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

  Future<Data<String>> cleanStart(RoomState room) async {
    _token ??= await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/rooms/clean-prod');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(room.toJson()),
    );
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
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

Future<Data<String>> cleanFinish(Room room) async {
    _token ??= await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/rooms/clean-finish');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(room.toJson()),
    );
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
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

  Future<Data<String>> generateReport(RoomState room) async {
    _token ??= await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/rooms/review');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(room.toJsonNoProducts()),
    );
    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
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