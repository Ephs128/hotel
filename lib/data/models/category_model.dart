import 'package:hotel/data/models/aux_product_model.dart';
class Category {
  int id;
  String name;
  int state; // 1 0
  int? registerUser;
  String registerDate;
  int type;
  List<AuxProduct> products;
  int selectedCount = 0;

  Category({
    required this.id,
    required this.name,
    required this.state, // 1 0
    this.registerUser,
    required this.registerDate,
    required this.type,
    required this.products,
  });

  factory Category.fromJson(Map<String,dynamic> json) {
    List<dynamic> products = json["productos"] ?? [];
    return Category(
      id: json["idCategoria"], 
      name: json["categoria"], 
      state: json["estado"], 
      registerUser: json["usuarioRegistro"],
      registerDate: json["fechaRegistro"], 
      type: json["tipo"], 
      products: products.map((value)=>AuxProduct.fromJson(value)).toList(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "idCategoria": id,
      "categoria": name,
      "estado": state,
      if (registerUser != null) "usuarioRegistro": registerUser,
      "fechaRegistro": registerDate,
      "tipo": type,
      "productos": products.map((value) => value.toJson()).toList(),
    };
  }
}