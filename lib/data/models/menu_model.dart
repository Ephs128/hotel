class Menu {
  final int id;
  final String menuCode;
  final bool active;
  final String description;
  final bool state;
  final int isMenu;
  final int idSubmnenu;
  final List<Menu> submenus;
  final List actions;

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
  });

  factory Menu.fromJson(Map<String, dynamic> json) { 
    List<dynamic> listMenus = json["submenus"];
    return Menu(
      id: json["idMenu"],
      menuCode: json["menuCode"],
      active: json["active"] == 1,
      description: json["description"],
      state: json["state"] == 1,
      isMenu: json["isMenu"],
      idSubmnenu: json["idSubmnenu"],
      submenus: listMenus.map((jsonData) => Menu.fromJson(jsonData)).toList(),
      actions: json["actions"],
    );
  }
  
}