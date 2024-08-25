import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/data/models/store_model.dart';
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

  Future<Data<String>> createUser(
    String name, 
    String firstLastname, 
    String secondLastname,
    String dni,
    String phone,
    String email,
    String address,
    String user,
    String password,
    String photo,
    String thumbnail,
    Role role,
    List<Cashbox> listCashboxes,
    List<Store> listStores
  ) async {
    String token = await storage.read(key: "token") ?? "";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/users/create');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "name": name,
        "firstLastname": firstLastname,
        "secondLastname": secondLastname,
        "dni": dni,
        "phone": phone,
        "email": email,
        "address": address,
        "user": {
            "user": user,
            "password": password,
            "photo": photo,
            "thumbnail": thumbnail,
            "idRole": role.id,
            "userCashboxes": listCashboxes.map((cashbox)=>{"idCashbox": cashbox.id}).toList(),
            "userStores": listStores.map((store) => {"idStore": store.id}).toList()
        },
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

  Future<Data<String>> updateUser(User user) async {
    String token = await storage.read(key: "token") ?? "";
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/users/update');
    var response = await client.put(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
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

  Future<Data<String>> deleteUser(User user) async {
    String token = await storage.read(key: "token") ?? "";
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/users/delete/${user.idUser}');
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