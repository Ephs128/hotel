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
    id: json["idStore"],
    name: json["storeName"],
    state: json["state"] == 1,
  );

  Map<String, dynamic> toJson() => {
    "idStore": id,
    "storeName": name,
    "state": state ? 1 : 0,
  };

  @override
  String toString() {
    return name;
  }
}