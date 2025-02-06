import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hotel/data/models/aux_sale_product_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/sale_model.dart';
import 'package:hotel/data/models/sale_product_model.dart';
import 'package:hotel/env.dart';

import 'package:http/http.dart' as http;

class SaleApi {
  final Env env;

  SaleApi({required this.env});

  Future<Data<Sale>> getSale(int idSale) async {
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/sales/one/$idSale');
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
        Sale sale = Sale.fromJson(jsonData["data"]);
        return Data(
          data: sale,
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

  Future<Data<String>> createSale(List<SaleProduct> saleProducts, List<AuxSaleProduct> newSaleProducts ) async {
    // List<Map<String,dynamic>> list = saleProducts.map((value) => value.toJson()).toList();
    // list += newSaleProducts.map((value) => value.toJson()).toList();
    // Map<String, dynamic> saleProductsList = {"ventaProductos": list};
    // log(jsonEncode(newSaleProducts.map((value) => value.toJson()).toList()));
    // return Data(data: null);
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/sales/create');
    try {
      var response = await client.post(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        },
        body: jsonEncode(newSaleProducts.map((value) => value.toJson()).toList()),
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