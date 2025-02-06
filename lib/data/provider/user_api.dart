import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/data/models/store_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/env.dart';
import 'package:http/http.dart' as http;

class UserApi {
  final Env env;

  UserApi({required this.env});

  Future<Data<List<User>>> getAllUsers() async{
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/users/list');
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
          data: listData.map((data) => User.fromJson(data)).toList(),
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
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/users/create');
    try {
      var response = await client.post(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        },
        body: jsonEncode({
          "nombre": name,
          "apellidoPaterno": firstLastname,
          "apellidoMaterno": secondLastname,
          "ci": dni,
          "telefono": phone,
          "correoElectronico": email,
          "direccion": address,
          "usuario": {
              "usuario": user,
              "contrasenia": password,
              "foto": photo,
              "miniatura": thumbnail,
              "idRol": role.id,
              "usuarioCajas": listCashboxes.map((cashbox)=>{"idCaja": cashbox.id}).toList(),
              "usuarioAlmacenes": listStores.map((store) => {"idAlmacen": store.id}).toList()
          },
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

  Future<Data<String>> updateUser(User user) async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/users/update');
    try {
      var response = await client.put(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        },
        body: jsonEncode(user.toJson()),
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