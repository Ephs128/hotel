class Store {
  int id;
  String name;
  bool state;

  Store({
    required this.id,
    required this.name,
    required this.state
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json["idAlmacen"],
    name: json["nombreAlmacen"],
    state: json["estado"] == 1,
  );

  Map<String, dynamic> toJson() => {
    "idAlmacen": id,
    "nombreAlmacen": name,
    "estado": state ? 1 : 0,
  };

  @override
  String toString() {
    return name;
  }
}