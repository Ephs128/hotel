class ProductCleanning {
  int productId;
  String productName;
  int cantity;

  ProductCleanning({
    required this.productId,
    required this.productName,
    required this.cantity,
  });

  factory ProductCleanning.fromJson(Map<String, dynamic> json) => ProductCleanning(
    productId: json["idProducto"],
    productName: json["nombreProducto"],
    cantity: json["cantidad"],
  );

  Map<String, dynamic> toJson() => {
    "idProducto": productId,
    "nombreProducto": productName,
    "cantidad": cantity,
  };
}