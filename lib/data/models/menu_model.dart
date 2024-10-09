import 'dart:developer';

import 'package:hotel/data/models/action_model.dart';

class Menu {

  static const String mRoomCode = "MMPHB";

  final String id;
  final String menuCode;
  final bool active;
  final String description;
  final bool state;
  final int isMenu;
  final int? idSubmnenu;
  final List<Menu> submenus;
  final Map<String, Action> actions;
  bool? selected;
  Menu? parentMenu;

  Menu({
    required this.id,
    required this.menuCode,
    required this.active,
    required this.description,
    required this.state,
    required this.isMenu,
    this.idSubmnenu,
    required this.submenus,
    required this.actions,
    this.selected = false,
    this.parentMenu,
  });

  factory Menu.fromJson(Map<String, dynamic> json) { 
    List<dynamic> listMenus = json["submenus"] ?? [];
    List<dynamic> listActions = json["acciones"] ?? [];
    Map<String,Action> mapActions = Map.fromEntries(
      listActions.map(
        (actionJson) {
          Action action = Action.fromJson(actionJson);
          return MapEntry(action.actionCode, action);
        }
      )
    );
    Menu instance = Menu(
      id: json["idMenu"],
      menuCode: json["codigoMenu"],
      active: json["activo"] == 1,
      description: json["descripcion"],
      state: json["estado"] == 1,
      isMenu: json["esMenu"],
      idSubmnenu: json["idSubmnenu"],
      submenus: listMenus.map((jsonData) => Menu.fromJson(jsonData)).toList(),
      actions: mapActions,
    );
    for(Menu submenu in instance.submenus) {
      submenu.parentMenu = instance;
    }
    return instance;
  }
  
  void calculateSelectedValue() {
    for(Menu submenu in submenus) {
      submenu.calculateSelectedValue();
    }
    bool areSame = true;
    bool? lastSelected;
    // todo: update
    // for(bool value in actions.values) {
    //   if (lastSelected == null) {
    //     lastSelected = value;
    //   } else {
    //     areSame = lastSelected == value;
    //     if (!areSame) {
    //       selected = null;
    //     }
    //   }
    // }
    if (areSame){
      for(Menu submenu in submenus) {
        if (lastSelected == null) {
          lastSelected = submenu.selected;
          selected = lastSelected;
        } else {
          areSame = lastSelected == submenu.selected;
          if (!areSame) {
            selected = null;
            break;
          }
        }
      }
    }
    if (areSame) {
      if (lastSelected != null) {
        selected = lastSelected;
      }
    }
  }

  void setState(bool newState) {
    // todo: update
    selected = newState;
    // for (String name in actions.keys) {
    //   actions[name] = newState;
    // }
    for (Menu submenu in submenus) {
      submenu.setState(newState);
    }
  }

  void updateAction(String action, bool value) {
    // todo: update
    // actions[action] = value;
  }
}