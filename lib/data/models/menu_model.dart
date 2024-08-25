import 'dart:developer';

class Menu {
  final int id;
  final String menuCode;
  final bool active;
  final String description;
  final bool state;
  final int isMenu;
  final int? idSubmnenu;
  final List<Menu> submenus;
  final Map<String,bool> actions;
  bool? selected;
  Menu? parentMenu;

  Menu({
    required this.id,
    required this.menuCode,
    required this.active,
    required this.description,
    required this.state,
    required this.isMenu,
    required this.idSubmnenu,
    required this.submenus,
    required this.actions,
    this.selected = false,
    this.parentMenu,
  });

  factory Menu.fromJson(Map<String, dynamic> json) { 
    List<dynamic> listMenus = json["submenus"];
    List<dynamic> listActions = json["actions"];
    Menu instance = Menu(
      id: json["idMenu"],
      menuCode: json["menuCode"],
      active: json["active"] == 1,
      description: json["description"],
      state: json["state"] == 1,
      isMenu: json["isMenu"],
      idSubmnenu: json["idSubmnenu"],
      submenus: listMenus.map((jsonData) => Menu.fromJson(jsonData)).toList(),
      actions: { for (var v in listActions) v.toString() : false },
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
    for(bool value in actions.values) {
      if (lastSelected == null) {
        lastSelected = value;
      } else {
        areSame = lastSelected == value;
        if (!areSame) {
          selected = null;
        }
      }
    }
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
    selected = newState;
    for (String name in actions.keys) {
      actions[name] = newState;
    }
    for (Menu submenu in submenus) {
      submenu.setState(newState);
    }
  }

  void updateAction(String action, bool value) {
    actions[action] = value;
  }
}