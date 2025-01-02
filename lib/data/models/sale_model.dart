import 'package:hotel/data/models/sale_product_model.dart';

class Sale {
  
  int id;
  String amount;
  String total;
  String change;
  String? dateRegister;
  List<SaleProduct> products;

  Sale({
    required this.id,
    required this.amount,
    required this.total,
    required this.change,
    this.dateRegister,
    required this.products,
  });

  factory Sale.fromJson(Map<String, dynamic> json) { 
    List<dynamic> products = json["ventaProductos"];
    return Sale(
      id: json["idVenta"],
      amount: json["monto"],
      total: json["total"],
      change: json["cambio"],
      dateRegister: json["fechaRegistro"],
      products: products.map((subJson) => SaleProduct.fromJson(subJson)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "idVenta": id,
    "monto": amount,
    "total": total,
    "cambio": change,
    "fechaRegistro": dateRegister,
    "ventaProductos": products.map((saleProduct) => saleProduct.toJson()).toList(),
  };
}