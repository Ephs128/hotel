import 'package:hotel/data/models/compound_model.dart';
import 'package:hotel/data/models/fee_model.dart';
import 'package:hotel/data/models/product_promo_model.dart';
import 'package:intl/intl.dart';

class Product {
  final int idProduct;
  final String productName;
  final String? description;
  String? position;
  String? productCode;
  String? serie;
  int? type;
  int? activate;
  int? productTYpe;
  int? idVenta;
  int? tolerance;
  int? toleranceCharge;
  int? toleranceOff;
  DateTime? time;
  String? actualTime;
  bool? automatic;
  bool? pulse;
  bool? selected;
  bool? state;
  int? userRegister;
  String? dateRegister;
  String? onUrl;
  String? offUrl;
  List<Compound> compounds;
  double? price;
  int? idFee;
  int? idCategory;
  Fee? fee;
  List<ProductPromo>? promos;
  int? idRoomState;
  int? idStore;
   
  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  Product({
    required this.idProduct,
    required this.productName,
    this.description,
    this.position,
    this.productCode,
    this.serie,
    this.type,
    this.productTYpe,
    this.activate,
    this.idVenta,
    this.tolerance,
    this.toleranceOff,
    this.time,
    this.automatic,
    this.pulse,
    this.selected,
    this.state,
    this.userRegister,
    this.dateRegister,
    this.price,
    this.onUrl,
    this.offUrl,
    required this.compounds,
    this.idFee,
    this.idCategory,
    this.fee,
    this.promos,
    this.toleranceCharge,
    this.actualTime,
    this.idRoomState,
  });

  factory Product.fromJson(Map<String, dynamic> json) { 
    List<dynamic> compoundList = json["compuestos"] ?? [];
    List<dynamic>? promoList = json["promocionProductos"];
    var auxVar = json["precio"];
    double? price;
    DateTime? time;
    Fee? fee;
    if (json["hora"] != null) {
      time = DateTime.parse(json["hora"]);
    }
    if (json["tarifa"] != null) {
      fee = Fee.fromJson(json["tarifa"]);
    }
    if(auxVar is String) {
      price = double.parse(auxVar);
    } else if (auxVar is double) {
      price = auxVar;
    }else if (auxVar is int) {
      price = auxVar.toDouble();
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
      userRegister: json["usuarioRegistro"],
      dateRegister: json["fechaRegistro"],
      price: price,
      onUrl: json["onUrl"],
      offUrl: json["offUrl"],
      compounds: compoundList.map((jsonData) => Compound.fromJson(jsonData)).toList(),
      idFee: json["idPrecio"],
      idCategory: json["idCategoria"],
      fee: fee,
      promos: promoList?.map((jsonData) => ProductPromo.fromJson(jsonData)).toList(),
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
    if (type != null) "tipo": type,
    if (productTYpe != null) "tipoDispositivo": productTYpe,
    if (activate != null) "activado": activate,
    if (idVenta != null) "idVenta": idVenta,
    if (tolerance != null) "tolerancia": tolerance,
    if (toleranceOff != null) "toleranciaOff": toleranceOff,
    if (time != null) "hora": _dateFormat.format(time!),
    if (automatic != null) "automatico":  automatic! ? 1 : 0,
    if (pulse != null) "pulso":  pulse! ? 1 : 0,
    if (selected != null) "seleccionado":  selected! ? 1 : 0,
    if (state != null) "estado":  state! ? 1 : 0,
    if (userRegister != null) "usuarioRegistro": userRegister,
    if (dateRegister != null) "fechaRegistro": dateRegister,
    if (price != null) "precio": price,
    if (onUrl != null) "onUrl": onUrl,
    if (offUrl != null) "offUrl": offUrl,
    "compuestos": compounds.map((compound) => compound.toJson()).toList(),
    if (idFee != null) "idPrecio": idFee,
    if (idCategory != null) "idCategoria": idCategory,
    if (fee != null) "tarifa": fee!.toJson(),
    if (promos != null) "promocionProductos": promos!.map((promo) => promo.toJson()).toList(),
    if (toleranceCharge != null) "toleranciaCobro": toleranceCharge,
    if (actualTime != null) "horaActual": actualTime,
    if (idRoomState != null) "idEstadoHabitacion": idRoomState,
    if (idStore != null) "idAlmacen": idStore,
  };

  @override
  String toString() {
    return productName;
  }

  void updateOnly(Product product) {
    if (idProduct == product.idProduct) {
      position = product.position;
      productCode = product.productCode;
      serie = product.serie;
      type = product.type;
      activate = product.activate;
      productTYpe = product.productTYpe;
      idVenta = product.idVenta;
      tolerance = product.tolerance;
      toleranceCharge = product.toleranceCharge;
      toleranceOff = product.toleranceOff;
      time = product.time;
      actualTime = product.actualTime;
      automatic = product.automatic;
      pulse = product.pulse;
      selected = product.selected;
      state = product.state;
      onUrl = product.onUrl;
      offUrl = product.offUrl;
      price = product.price;
      idFee = product.idFee;
      idCategory = product.idCategory;
      idRoomState = product.idRoomState;
    }
  }
  
  @override
  bool operator ==(Object other) {
    bool ans = other is Product;
    if (ans) {
      ans = idProduct == other.idProduct;
    }
    return ans;
  } 

  @override
  int get hashCode => idProduct.hashCode;

}