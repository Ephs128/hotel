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
    id: json["idUsuarioAlmacen"], 
    state: json["estado"] == 1, 
    idUser: json["idUsuario"], 
    idStore: json["idAlmacen"],
  );

  Map<String, dynamic> toJson() => {
    "idUsuarioAlmacen": id,
    "estado": state ? 1 : 0,
    "idUsuario": idUser,
    "idAlmacen": idStore,
  };
  
}