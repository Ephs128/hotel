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
        id: json["idRole"],
        role: json["role"],
        state: json["state"] == 1,
    );

    Map<String, dynamic> toJson() => {
        "idRole": id,
        "role": role,
        "state": state ? 1 : 0,
    };
}