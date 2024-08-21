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
    id: json["idUserCashbox"], 
    state: json["state"] == 1, 
    idUser: json["idUser"], 
    idCashbox: json["idCashbox"],
  );

  Map<String, dynamic> toJson() => {
    "idUserCashbox": id,
    "state": state ? 1 : 0,
    "idUser": idUser,
    "idCashbox": idCashbox,
  };
  
}