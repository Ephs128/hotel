import 'package:hotel/data/models/promo_model.dart';

class ProductPromo {
  final int idPromocion;
  final int idProduct;
  final Promo promo;

  ProductPromo({
    required this.idPromocion,
    required this.idProduct,
    required this.promo,
  });

  factory ProductPromo.fromJson( Map<String, dynamic> json) => ProductPromo(
    idPromocion: json["idPromocion"], 
    idProduct: json["idProducto"], 
    promo: Promo.fromJson(json["promocion"]), 
  );

  Map<String, dynamic> toJson() => {
    "idPromocion": idPromocion,
    "idProducto": idProduct,
    "promocion": promo.toJson(),
  };

}