import 'package:hotel/data/models/product_model.dart';

class Room {
  Product product;
  late int id;
  late String name;
  late String statename;
  late bool? state;
  static const String free = "Libre"; 
  static const String inUse = "Ocupado"; 
  static const String dirty = "Sucio"; 
  static const String cleaning = "En limpieza"; 
  static const String maintenance = "En mantenimiento"; 
  static const String outService = "Fuera de servicio";
  static const String review = "En revisión";
  static const String vip = "VIP"; 
  static const String defaultState = "Estado no considerado"; 
  static const String charging = "Cobrando"; 

  Room({
    required this.product,
  }) {
    name = product.productName;
    id = product.idProduct;
    state = product.state;
    switch(product.activate) {
      case 0:
        statename = free;
      case 1:
        statename = inUse;
      case 2:
        statename = dirty;
      case 3:
        statename = cleaning;
      case 4:
        statename = maintenance;
      case 5:
        statename = outService;
      case 6:
        statename = review;
      case 7:
        statename = charging;
      default:
        statename = defaultState;
    }
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(product: Product.fromJson(json));
  } 

  Map<String, dynamic> toJson() => product.toJson();

  void update(Room room) {
    if (id == room.id) {
      name = room.name;
      statename = room.statename;
      state = room.state;
      product.updateOnly(room.product);
    }
  }

}