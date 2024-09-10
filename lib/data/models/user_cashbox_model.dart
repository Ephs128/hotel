class UserCashbox {
  
  final int id;
  final bool state;
  final int idUser;
  final int idCashbox;

  UserCashbox({
    required this.id,
    required this.state, 
    required this.idUser, 
    required this.idCashbox, 
  });

  factory UserCashbox.fromJson(Map<String, dynamic> json) => UserCashbox(
    id: json["idUsuarioCaja"], 
    state: json["estado"] == 1, 
    idUser: json["idUsuario"], 
    idCashbox: json["idCaja"],
  );

  Map<String, dynamic> toJson() => {
    "idUsuarioCaja": id,
    "estado": state ? 1 : 0,
    "idUsuario": idUser,
    "idCaja": idCashbox,
  };
  
}