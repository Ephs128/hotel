import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/category_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/sale_product_model.dart';
import 'package:hotel/data/models/store_product_model.dart';
import 'package:http/http.dart' as http;
import 'package:hotel/data/env.dart';

class ProductApi {
  final storage = const FlutterSecureStorage();

  Future<Data<List<StoreProduct>>> getAllProducts(int idStore) async{
    String token = await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/products/list/$idStore');
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
        data: listData.map((data) => StoreProduct.fromJson(data)).toList(),
      );
    } else {
      return Data(
        message: jsonData["message"],
        statusCode: jsonData["status"],
        data: null
      );
    }
  }

  Future<Data<List<Category>>> getProductsAvailables() async {
    String token = await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/categories/list-prod/1');
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
        data: listData.map((data) => Category.fromJson(data)).toList(),
      );
    } else {
      return Data(
        message: jsonData["message"],
        statusCode: jsonData["status"],
        data: null
      );
    }
  }

  Future<Data<List<SaleProduct>>> getProductsInSale(int idSale) async {
    String token = await storage.read(key: "token") ?? "wtf?";

    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/products/listsale/$idSale');
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
        data: listData.map((data) => SaleProduct.fromJson(data)).toList(),
      );
    } else {
      return Data(
        message: jsonData["message"],
        statusCode: jsonData["status"],
        data: null
      );
    }
  }

  Future<Data<String>> deleteProductInSale(SaleProduct saleProduct) async {
    String token = await storage.read(key: "token") ?? "wtf?";
    log(jsonEncode(saleProduct.toJson()));
    var client = http.Client();
    var uri = Uri.parse('$baseURL/api/v1/sales/deleteproduct');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(saleProduct.toJson()),
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