class UserStore {
  
  final int id;
  final bool state;
  final int idUser;
  final int idStore;

  UserStore({
    required this.id,
    required this.state, 
    required this.idUser, 
    required this.idStore, 
  });

  factory UserStore.fromJson(Map<String, dynamic> json) => UserStore(
    id: json["idUserStore"], 
    state: json["state"] == 1, 
    idUser: json["idUser"], 
    idStore: json["idStore"],
  );

  Map<String, dynamic> toJson() => {
    "idUserStore": id,
    "state": state ? 1 : 0,
    "idUser": idUser,
    "idStore": idStore,
  };
  
}