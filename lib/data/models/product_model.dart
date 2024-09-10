class Product {
  final String productName;
  final String description;
  final int type;
  final double price;

  Product({
    required this.productName,
    required this.description,
    required this.type,
    required this.price,
  });

  @override
  String toString() {
    return productName;
  }
}