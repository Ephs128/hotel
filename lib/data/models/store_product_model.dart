import 'package:hotel/data/models/product_model.dart';

class StoreProduct {
  final int idStorage;
  final int idProduct;
  final String cantity;
  final String virtualCantity;
  final String buyPrice;
  final String sellPrice;
  final int measureUnit;
  final bool state;
  final Product product;

  StoreProduct({
    required this.idStorage,
    required this.idProduct,
    required this.cantity,
    required this.virtualCantity,
    required this.buyPrice,
    required this.sellPrice,
    required this.measureUnit,
    required this.state,
    required this.product,
  });


  factory StoreProduct.fromJson(Map<String, dynamic> json) => StoreProduct(
    idStorage: json["idAlmacen"],
    idProduct: json["idProducto"],
    cantity: json["cantidad"],
    virtualCantity: json["cantidadVirtual"],
    buyPrice: json["precioCompra"],
    sellPrice: json["precioVenta"],
    measureUnit: json["unidadMedida"],
    state: json["estado"] == 1,
    product: Product.fromJson(json["producto"]),
  );
}