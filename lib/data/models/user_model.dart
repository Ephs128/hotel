import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/person_model.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/data/models/store_model.dart';

class User {
  int idUser;
  String user;
  String password;
  String photo;
  String thumbnail;
  bool state;
  int registerUser;
  Person person;
  Role role;
  // List<Store> stores;
  // List<Cashbox> cashboxes;

  User({
    required this.idUser,
    required this.user,
    required this.password,
    required this.photo,
    required this.thumbnail,
    required this.state,
    required this.registerUser,
    required this.person,
    required this.role,
    // required this.stores,
    // required this.cashboxes,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    idUser: json["idUser"],
    user: json["user"],
    password: json["password"],
    photo: json["photo"],
    thumbnail: json["thumbnail"],
    state: json["state"] == 1,
    registerUser: json["registerUser"],
    person: Person.fromJson(json["person"]),
    role: Role.fromJson(json["role"]),
  );

  Map<String, dynamic> toJson() => {
    "idUser": idUser,
    "user": user,
    "password": password,
    "photo": photo,
    "thumbnail": thumbnail,
    "state": state ? 1 : 0,
    "registerUser": registerUser,
    "person": person.toJson(),
    "rol": role.toJson(),
  };
    
}

