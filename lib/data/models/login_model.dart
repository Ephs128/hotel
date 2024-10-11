import 'dart:developer';

import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/data/models/user_model.dart';

class Login {
  final User user;
  final List<Menu> menus;
  final String token;
  final String homeassistantURL;
  final String homeassistantToken;

  Login({
    required this.user,
    required this.menus,
    required this.token,
    required this.homeassistantURL,
    required this.homeassistantToken,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    List<dynamic> listMenu = json["menus"];
    log("data usuario:");
    log(json["usuario"].toString());
    return Login(
      user: User.fromJson(json["usuario"]),
      menus: listMenu.map((menuJson) => Menu.fromJson(menuJson)).toList(),
      token: json["token"],
      homeassistantURL: json["config"]["url"],
      homeassistantToken: json["config"]["token"],
    );
  }

  Map<String, dynamic> toJson() => {
    "usuario": user.toJson(),
    "menus": menus.map((menu) => menu.toJson(),).toList(),
    "token": token,
    "config": {
      "url": homeassistantURL,
      "token": homeassistantToken,
    }
  };
}