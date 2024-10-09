import 'package:hotel/data/models/compound_model.dart';
import 'package:hotel/data/models/fee_model.dart';
import 'package:hotel/data/models/promo_model.dart';
import 'package:intl/intl.dart';

class Product {
  final int idProduct;
  final String productName;
  final String? description;
  final String? position;
  final String? productCode;
  final String? serie;
  final int type;
  int activate;
  final int? productTYpe;
  final int? idVenta;
  final int? tolerance;
  final int? toleranceCharge;
  final int? toleranceOff;
  DateTime? time;
  String? actualTime;
  final bool? automatic;
  final bool? pulse;
  final bool? selected;
  final bool state;
  final String? onUrl;
  final String? offUrl;
  final List<Compound> compounds;
  final String? price;
  final int? idFee;
  final int? idCategory;
  final Fee? fee;
  final List<Promo> promos;
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  final int? idRoomState;
   

  Product({
    required this.idProduct,
    required this.productName,
    required this.description,
    this.position,
    this.productCode,
    this.serie,
    required this.type,
    this.productTYpe,
    required this.activate,
    this.idVenta,
    this.tolerance,
    this.toleranceOff,
    this.time,
    this.automatic,
    this.pulse,
    this.selected,
    required this.state,
    this.price,
    this.onUrl,
    this.offUrl,
    required this.compounds,
    this.idFee,
    this.idCategory,
    this.fee,
    required this.promos,
    this.toleranceCharge,
    this.actualTime,
    this.idRoomState,
  });

  factory Product.fromJson(Map<String, dynamic> json) { 
    List<dynamic> compoundList = json["compuestos"] ?? [];
    List<dynamic> promoList = json["promocionProductos"] ?? [];
    DateTime? time;
    Fee? price;
    if (json["hora"] != null) {
      time = DateTime.parse(json["hora"]);
    }
    if (json["tarifa"] != null) {
      price = Fee.fromJson(json["tarifa"]);
    }
    return Product(
      idProduct: json["idProducto"],
      productName: json["nombreProducto"],
      description: json["descripcion"],
      position: json["posicion"],
      productCode: json["codigoProducto"],
      serie: json["serie"],
      type: json["tipo"],
      productTYpe: json["tipoDispositivo"],
      activate: json["activado"],
      idVenta: json["idVenta"],
      tolerance: json["tolerancia"],
      toleranceOff: json["toleranciaOff"],
      time: time,
      automatic: json["automatico"] == 1,
      pulse: json["pulso"] == 1,
      selected: json["seleccionado"] == 1,
      state: json["estado"] == 1,
      price: json["precio"],
      onUrl: json["onUrl"],
      offUrl: json["offUrl"],
      compounds: compoundList.map((jsonData) => Compound.fromJson(jsonData)).toList(),
      idFee: json["idPrecio"],
      idCategory: json["idCategoria"],
      fee: price,
      promos: promoList.map((jsonData) => Promo.fromJson(jsonData)).toList(),
      toleranceCharge: json["toleranciaCobro"],
      actualTime: json["horaActual"],
      idRoomState: json["idEstadoHabitacion"],
    );
  }

  Map<String, dynamic> toJson() => {
    "idProducto": idProduct,
    "nombreProducto": productName,
    if (description != null) "descripcion": description,
    if (position != null) "posicion": position,
    if (productCode != null) "codigoProducto": productCode,
    if (serie != null) "serie": serie,
    "tipo": type,
    if (productTYpe != null) "tipoDispositivo": productTYpe,
    "activado": activate,
    if (idVenta != null) "idVenta": idVenta,
    if (tolerance != null) "tolerancia": tolerance,
    if (toleranceOff != null) "toleranciaOff": toleranceOff,
    if (time != null) "hora": dateFormat.format(time!),
    if (automatic != null) "automatico":  automatic! ? 1 : 0,
    if (pulse != null) "pulso":  pulse! ? 1 : 0,
    if (selected != null) "seleccionado":  selected! ? 1 : 0,
    "estado":  state ? 1 : 0,
    if (price != null) "precio": price,
    if (onUrl != null) "onUrl": onUrl,
    if (offUrl != null) "offUrl": offUrl,
    "compuestos": compounds.map((compound) => compound.toJson()).toList(),
    if (idFee != null) "idPrecio": idFee,
    if (idCategory != null) "idCategoria": idCategory,
    if (fee != null) "tarifa": fee!.toJson(),
    "promocionProductos": promos.map((promo) => promo.toJson()).toList(),
    if (toleranceCharge != null) "toleranciaCobro": toleranceCharge,
    if (actualTime != null) "horaActual": actualTime,
    if (idRoomState != null) "idEstadoHabitacion": idRoomState,
  };

  @override
  String toString() {
    return productName;
  }
}