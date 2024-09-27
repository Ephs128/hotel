import 'package:hotel/data/models/product_model.dart';

class Room {
  final Product product;
  late int id;
  late String name;
  late String state;
  late bool isActive;
  static const String free = "Libre"; 
  static const String inUse = "Ocupado"; 
  static const String dirty = "Sucio"; 
  static const String cleaning = "En limpieza"; 
  static const String maintenance = "En mantenimiento"; 

  Room({
    required this.product,
  }) {
    name = product.productName;
    id = product.idProduct;
    isActive = product.state;
    switch(product.activate) {
      case 0:
        state = free;
      case 1:
        state = inUse;
      case 2:
        state = dirty;
      case 3:
        state = cleaning;
      case 4:
        state = maintenance;
    }
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(product: Product.fromJson(json));
  } 

  Map<String, dynamic> toJson() => product.toJson();

}