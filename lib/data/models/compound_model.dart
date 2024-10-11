import 'package:hotel/data/models/product_model.dart';

class Compound {
  final int id;
  final bool state;
  final int idProduct;
  final int idSubproduct;
  Product subproduct;

  Compound({
    required this.id,
    required this.state,
    required this.idProduct,
    required this.idSubproduct,
    required this.subproduct,
  });

  factory Compound.fromJson(Map<String, dynamic> json) => Compound(
    id: json["idCompuesto"],
    state: json["estado"] == 1,
    idProduct:  json["idProducto"],
    idSubproduct:  json["idSubproducto"],
    subproduct: Product.fromJson(json["subproducto"]),
  );

  Map<String, dynamic> toJson() => {
    "idCompuesto": id,
    "estado":  state ? 1 : 0,
    "idProducto": idProduct,
    "idSubproducto": idSubproduct,
    "subproducto": subproduct.toJson(),
  };
  
}