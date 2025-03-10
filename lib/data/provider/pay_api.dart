import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/income_expenses_model.dart';
import 'package:hotel/data/models/promo_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/models/sale_model.dart';
import 'package:hotel/data/models/sale_product_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/service/sale_service.dart';
import 'package:hotel/env.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PayApi {
  
  final Env env;
  final dateFormat = DateFormat('yyyy-MM-dd');
  final timeFormat = DateFormat('hh:mm:ss');
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  PayApi({required this.env});

  Future<Data<String>> postPay (
    String time, 
    Room room,
    double roomAmountCharged,
    double amountCharged, 
    User user,
    int selectedOption,
    double amountCash,
    double amountTransfer,
    double amountQr,
    String description,
    int idCashbox,
    Promo? selectedPromo,
  ) async {
    DateTime now = DateTime.now();
    Map<String, dynamic> body = {};
    room.product.actualTime = time;
    room.product.price = roomAmountCharged;
    Map<String, dynamic> jsonRoom = room.toJson();
    jsonRoom["idAlmacen"] = user.stores.first;
    int idSale = room.product.idVenta!;
    Data<Sale> saleData = await SaleService(env: env).getSale(idSale);
    Sale sale = saleData.data!;
    sale.amount = amountCharged.toString();
    sale.total = amountCharged.toString();
    SaleProduct roomSale = SaleProduct(idSale: idSale, idProduct: room.id, price: roomAmountCharged, product: room.product);
    sale.products.add(roomSale);
    body["habitacion"] = room.toJson();
    body["venta"] = sale.toJson();
    body["ventaProductos"] = [roomSale.toJson()];
    body["ingresoEgreso"] = {
      "idIngresoEgreso": null,
      "monto": amountCharged,
      "montoT": amountTransfer,
      "montoQ": amountQr,
      "montoE": amountCash,
      "fecha": dateFormat.format(now),
      "hora": timeFormat.format(now),
      "descripcion": description,
      "tipo": selectedOption == 2 || selectedOption == 3 ? 3 : 4,
      "idCaja": idCashbox,
      "idVenta": idSale,
      "tipoPago": selectedOption,
      "esPromo": selectedPromo != null,
      "idPromocion": selectedPromo?.id,
    };
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/pays/pay');
    try {
      var response = await client.post(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      final postResult = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Data(
          data: postResult["data"]["message"],
        );
      } else {
        return Data(
          message: postResult["message"],
          statusCode: postResult["status"],
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

  Future<Data<String>> pay (Room room) async {
    String? saved = await storage.read(key: "room_${room.id}");
    if (saved == null) {
      return Data(
        message: "No se tiene los datos para finalizar el cobro de esta habitación. Realizar el cobro desde el dispositivo que se sacó la cuenta",
        statusCode: 400,
        data: null
      );
    } 
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/pays/pay');
    try {
      var response = await client.post(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        },
        body: saved,
      ).timeout(const Duration(seconds: 10));
      final postResult = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Data(
          data: postResult["data"]["message"],
        );
      } else {
        return Data(
          message: postResult["message"],
          statusCode: postResult["status"],
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

  Future<Data<String>> prePay (
    String time, 
    Room room,
    double roomAmountCharged,
    double amountCharged, 
    User user,
    int selectedOption,
    double amountCash,
    double amountTransfer,
    double amountQr,
    String description,
    int idCashbox,
    Promo? selectedPromo,
  ) async {
    DateTime now = DateTime.now();
    Map<String, dynamic> body = {};
    room.product.actualTime = time;
    room.product.price = roomAmountCharged;
    Map<String, dynamic> jsonRoom = room.toJson();
    jsonRoom["idAlmacen"] = user.stores.first;
    int idSale = room.product.idVenta!;
    Data<Sale> saleData = await SaleService(env: env).getSale(idSale);
    Sale sale = saleData.data!;
    sale.amount = amountCharged.toString();
    sale.total = amountCharged.toString();
    SaleProduct roomSale = SaleProduct(idSale: idSale, idProduct: room.id, price: roomAmountCharged, product: room.product);
    sale.products.add(roomSale);
    body["habitacion"] = room.toJson();
    body["venta"] = sale.toJson();
    body["ventaProductos"] = [roomSale.toJson()];
    body["ingresoEgreso"] = {
      "idIngresoEgreso": null,
      "monto": amountCharged,
      "montoT": amountTransfer,
      "montoQ": amountQr,
      "montoE": amountCash,
      "fecha": dateFormat.format(now),
      "hora": timeFormat.format(now),
      "descripcion": description,
      "tipo": selectedOption == 2 || selectedOption == 3 ? 3 : 4,
      "idCaja": idCashbox,
      "idVenta": idSale,
      "tipoPago": selectedOption,
      "esPromo": selectedPromo != null,
      "idPromocion": selectedPromo?.id,
    };
    var client = http.Client();
    var uri = Uri.parse('${env.baseUrl}/api/v1/pays/prepay');
    try {
      var response = await client.post(
        uri, 
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${env.token}',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      final postResult = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Data(
          data: postResult["data"]["message"],
        );
      } else {
        return Data(
          message: postResult["message"],
          statusCode: postResult["status"],
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