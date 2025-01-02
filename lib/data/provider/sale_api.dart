import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/aux_sale_product_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/sale_model.dart';
import 'package:hotel/data/models/sale_product_model.dart';

import 'package:http/http.dart' as http;
import 'package:hotel/data/env.dart';

class SaleApi {
  final storage = const FlutterSecureStorage();
  String? _token;

  Future<Data<Sale>> getSale(int idSale) async {
    _token ??= await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/sales/one/$idSale');
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
  }

  Future<Data<String>> createSale(List<SaleProduct> saleProducts, List<AuxSaleProduct> newSaleProducts ) async {
    List<Map<String,dynamic>> list = saleProducts.map((value) => value.toJson()).toList();
    list += newSaleProducts.map((value) => value.toJson()).toList();
    _token ??= await storage.read(key: "token") ?? "wtf?";
    Map<String, dynamic> saleProductsList = {"ventaProductos": list};
    log(jsonEncode(newSaleProducts.map((value) => value.toJson()).toList()));
    // return Data(data: null);
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/sales/create');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(newSaleProducts.map((value) => value.toJson()).toList()),
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