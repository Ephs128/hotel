class Action {
  final String id;
  final String actionCode;
  final bool active;
  final String description;
  final bool state;
  final int idActionMenu;

  Action({
    required this.id,
    required this.actionCode,
    required this.active,
    required this.description,
    required this.state,
    required this.idActionMenu,
  });

  factory Action.fromJson(Map<String,dynamic> json) => Action(
    id: json["idAccion"],
    actionCode: json["codigoAccion"],
    active: json["activo"] == 1,
    description: json["descripcion"],
    state: json["estado"] == 1,
    idActionMenu: json["idMenuAccion"],
  );

  Map<String, dynamic> toJson() => {
    "idAccion": id,
    "codigoAccion": actionCode,
    "activo": active ? 1 : 0,
    "descripcion": description,
    "estado": state ? 1 : 0,
    "idMenuAccion": idActionMenu,
  };
}