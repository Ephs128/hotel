import 'package:hotel/data/models/product_model.dart';

class SaleProduct {
  
  int? id;
  int idSale;
  int idProduct;
  double price;
  Product product;
  String? registerDate;

  SaleProduct({
    this.id,
    required this.idSale,
    required this.idProduct,
    required this.price,
    required this.product,
    this.registerDate,
  });

  factory SaleProduct.fromJson(Map<String, dynamic> json) => SaleProduct(
    id: json["idVentaProducto"], 
    idSale: json["idVenta"], 
    idProduct: json["idProducto"], 
    price: json["precio"] is String ? double.parse(json["precio"]) : json["precio"], 
    registerDate: json["fechaRegistro"],
    product: Product.fromJson(json["producto"]), 
  );

  Map<String, dynamic> toJson() => {
    "idVentaProducto": id,
    "idVenta": idSale,
    "idProducto": idProduct,
    "precio": price,
    if(registerDate != null) "fechaRegistro": registerDate,
    "producto": product.toJson(),
  };
}