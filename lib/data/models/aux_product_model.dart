import 'package:hotel/data/models/compound_model.dart';

class AuxProduct {
  final int idProduct;
  final String productName;
  int type;
  List<Compound> compounds;
  double price;
  double cantity;
  int measurement;
  int registerUser;
  int? idStore;

  AuxProduct({
    required this.idProduct,
    required this.productName,
    required this.type,
    required this.compounds,
    required this.price,
    required this.cantity,
    required this.measurement,
    required this.registerUser,
  });

  factory AuxProduct.fromJson(Map<String, dynamic> json) { 
    List<dynamic> compoundList = json["compuestos"] ?? [];
    return AuxProduct(
      idProduct: json["idProducto"],
      productName: json["nombreProducto"],
      type: json["tipo"],
      price: double.parse(json["precio"]),
      compounds: compoundList.map((jsonData) => Compound.fromJson(jsonData)).toList(),
      cantity: double.parse(json["cantidad"]),
      measurement: json["unidadMedida"],
      registerUser: json["usuarioRegistro"],
    );
  }

  Map<String, dynamic> toJson() => {
    "idProducto": idProduct,
    "nombreProducto": productName,
    "tipo": type,
    "precio": price.toString(),
    "compuestos": compounds.map((compound) => compound.toJson()).toList(),
    "cantidad": cantity.toString(),
    "unidadMedida": measurement,
    "usuarioRegistro": registerUser,
    if (idStore != null) "idAlmacen": idStore,
  };
}