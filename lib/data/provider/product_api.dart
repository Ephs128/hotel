import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hotel/data/models/category_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/sale_product_model.dart';
import 'package:hotel/data/models/store_product_model.dart';
import 'package:hotel/env.dart';
import 'package:http/http.dart' as http;

class ProductApi {

  final Env env;

  ProductApi({required this.env});

  Future<Data<List<StoreProduct>>> getAllProducts(int idStore) async{
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/products/list/$idStore');
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
          data: listData.map((data) => StoreProduct.fromJson(data)).toList(),
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

  Future<Data<List<Category>>> getProductsAvailables() async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/categories/list-prod/1');
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
          data: listData.map((data) => Category.fromJson(data)).toList(),
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

  Future<Data<List<SaleProduct>>> getProductsInSale(int idSale) async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/products/listsale/$idSale');
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
          data: listData.map((data) => SaleProduct.fromJson(data)).toList(),
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

  Future<Data<String>> deleteProductInSale(SaleProduct saleProduct) async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/sales/deleteproduct');
    try {
      var response = await client.post(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        },
        body: jsonEncode(saleProduct.toJson()),
      ).timeout(const Duration(seconds: 10));
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