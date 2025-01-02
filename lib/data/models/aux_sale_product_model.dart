import 'package:hotel/data/models/aux_product_model.dart';

class AuxSaleProduct {
  
  // int? id;
  int idSale;
  int idProduct;
  double price;
  AuxProduct product;

  AuxSaleProduct({
    // this.id,
    required this.idSale,
    required this.idProduct,
    required this.price,
    required this.product,
  });

  // factory AuxSaleProduct.fromJson(Map<String, dynamic> json) => AuxSaleProduct(
  //   id: json["idVentaProducto"], 
  //   idSale: json["idVenta"], 
  //   idProduct: json["idProducto"], 
  //   price: json["precio"] is String ? double.parse(json["precio"]) : json["precio"], 
  //   product: AuxProduct.fromJson(json["producto"]), 
  // );

  Map<String, dynamic> toJson() => {
    // if (id != null) "idVentaProducto": id,
    "idVenta": idSale,
    "idProducto": idProduct,
    "precio": price,
    "producto": product.toJson(),
  };

}