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
  Person? person;
  Role? role;
  int idRole;
  int? idSession;
  List<UserStore> stores;
  List<UserCashbox> cashboxes;

  User({
    required this.idUser,
    required this.user,
    required this.password,
    required this.photo,
    required this.thumbnail,
    required this.state,
    this.person,
    required this.role,
    required this.idRole,
    required this.stores,
    required this.cashboxes,
    this.idSession,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<dynamic> listStores = json["usuarioAlmacenes"];
    List<dynamic> listCashboxes = json["usuarioCajas"];
    Person? person;
    if(json["persona"] != null) {
      person = Person.fromJson(json["persona"]); 
    }
    Role? role;
    if(json["rol"] != null) {
      role = Role.fromJson(json["rol"]); 
    }
    return User(
      idUser: json["idUsuario"],
      user: json["usuario"],
      password: json["contrasenia"],
      photo: json["foto"],
      thumbnail: json["miniatura"],
      state: json["estado"] == 1,
      person: person,
      role: role,
      idRole: json["idRol"],
      idSession: json["idSesion"],
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
    if (person != null) "persona": person!.toJson(),
    if (role != null) "rol": role!.toJson(),
    "idRol": idRole,
    if(idSession != null) "idSesion": idSession,
    "usuarioAlmacenes": stores.map((store) => store.toJson()).toList(),
    "usuarioCajas": cashboxes.map((cashbox) => cashbox.toJson()).toList(),
  };
    
}

