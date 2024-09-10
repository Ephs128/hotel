import 'package:hotel/data/models/person_model.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/data/models/user_cashbox_model.dart';
import 'package:hotel/data/models/user_store_model.dart';

class User {
  int idUser;
  String user;
  String password;
  String photo;
  String thumbnail;
  bool state;
  Person person;
  Role role;
  List<UserStore> stores;
  List<UserCashbox> cashboxes;

  User({
    required this.idUser,
    required this.user,
    required this.password,
    required this.photo,
    required this.thumbnail,
    required this.state,
    required this.person,
    required this.role,
    required this.stores,
    required this.cashboxes,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<dynamic> listStores = json["usuarioAlmacenes"];
    List<dynamic> listCashboxes = json["usuarioCajas"];
    
    return User(
      idUser: json["idUsuario"],
      user: json["usuario"],
      password: json["contrasenia"],
      photo: json["foto"],
      thumbnail: json["miniatura"],
      state: json["estado"] == 1,
      person: Person.fromJson(json["persona"]),
      role: Role.fromJson(json["rol"]),
      stores: listStores.map((jsonData) => UserStore.fromJson(jsonData)).toList(),
      cashboxes: listCashboxes.map((jsonData) => UserCashbox.fromJson(jsonData)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "idUsuario": idUser,
    "usuario": user,
    "contrasenia": password,
    "foto": photo,
    "miniatura": thumbnail,
    "estado": state ? 1 : 0,
    "persona": person.toJson(),
    "rol": role.toJson(),
    "userStores": stores.map((store) => store.toJson()).toList(),
    "userCashboxes": cashboxes.map((cashbox) => cashbox.toJson()).toList(),
  };
    
}

