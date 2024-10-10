import 'package:hotel/data/models/product_model.dart';

class Room {
  Product product;
  late int id;
  late String name;
  late String state;
  late bool isActive;
  static const String free = "Libre"; 
  static const String inUse = "Ocupado"; 
  static const String dirty = "Sucio"; 
  static const String cleaning = "En limpieza"; 
  static const String maintenance = "En mantenimiento"; 
  static const String outService = "Fuera de servicio";
  static const String review = "En revisión";
  static const String vip = "VIP"; 
  static const String defaultState = "Estado no considerado"; 

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
      case 5:
        state = outService;
      case 6:
        state = review;
      case 7:
        state = vip;
      default:
        state = defaultState;
    }
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(product: Product.fromJson(json));
  } 

  Map<String, dynamic> toJson() => product.toJson();

  void update(Room room) {
    if (id == room.id) {
      name = room.name;
      state = room.state;
      isActive = room.isActive;
      product.updateOnly(room.product);
    }
  }

}