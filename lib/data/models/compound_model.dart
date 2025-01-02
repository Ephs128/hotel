import 'package:hotel/data/models/product_model.dart';

class Compound {
  final int id;
  final bool state;
  final int idProduct;
  final int idSubproduct;
  int? cantity;
  String? registerDate;
  int? registerUser;
  Product? subproduct;

  Compound({
    required this.id,
    required this.state,
    required this.idProduct,
    required this.idSubproduct,
    this.cantity,
    this.registerDate,
    this.registerUser,
    this.subproduct,
  });

  factory Compound.fromJson(Map<String, dynamic> json) => Compound(
    id: json["idCompuesto"],
    state: json["estado"] == 1,
    idProduct:  json["idProducto"],
    idSubproduct:  json["idSubproducto"],
    cantity: json["cantidad"],
    registerDate: json["fechaRegistro"],
    registerUser: json["usuarioRegistro"],
    subproduct: json["subproducto"] == null? null :Product.fromJson(json["subproducto"]),
  );

  Map<String, dynamic> toJson() => {
    "idCompuesto": id,
    "estado":  state ? 1 : 0,
    "idProducto": idProduct,
    "idSubproducto": idSubproduct,
    if (cantity != null) "cantidad": cantity,
    if (registerDate != null) "fechaRegistro": registerDate,
    if (registerUser != null) "usuarioRegistro": registerUser,
    if (subproduct != null) "subproducto": subproduct!.toJson(),
  };
  
}