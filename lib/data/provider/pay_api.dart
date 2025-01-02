import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/promo_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/models/sale_model.dart';
import 'package:hotel/data/models/sale_product_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/service/sale_service.dart';
import 'package:http/http.dart' as http;
import 'package:hotel/data/env.dart';
import 'package:intl/intl.dart';

class PayApi {
  final storage = const FlutterSecureStorage();
  final dateFormat = DateFormat('yyyy-MM-dd');
  final timeFormat = DateFormat('hh:mm:ss');
  String? _token;

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
    _token = await storage.read(key: "token") ?? "wtf?";
    DateTime now = DateTime.now();
    Map<String, dynamic> body = {};
    room.product.actualTime = time;
    room.product.price = roomAmountCharged;
    Map<String, dynamic> jsonRoom = room.toJson();
    jsonRoom["idAlmacen"] = user.stores.first;
    int idSale = room.product.idVenta!;
    Data<Sale> saleData = await SaleService().getSale(idSale);
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
    var uri = Uri.parse('$baseURL/api/v1/pays/pay');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(body),
    );
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
  }
}