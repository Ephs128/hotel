class Role {
  final int id;
  final String role;
  final bool state;

  Role({
    required this.id, 
    required this.role, 
    required this.state
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["idRol"],
    role: json["rol"],
    state: json["estado"] == 1,
  );

  Map<String, dynamic> toJson() => {
    "idRol": id,
    "rol": role,
    "estado": state ? 1 : 0,
  };

  @override
  String toString() {
    return role;
  }

  @override
  bool operator == (Object other) {
    return other is Role && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
}