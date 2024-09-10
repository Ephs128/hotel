class Person {
  final int id;
  final String name;
  final String firstLastname;
  final String? secondLastname;
  final String identityDocument;
  final String phone;
  final String email;
  final String address;

  Person({
    required this.id, 
    required this.name, 
    required this.firstLastname, 
    required this.secondLastname, 
    required this.identityDocument, 
    required this.phone, 
    required this.email, 
    required this.address,
  });
  
  factory Person.fromJson(Map<String, dynamic> json) => Person(
    id: json["idPersona"],
    name: json["nombre"],
    firstLastname: json["apellidoPaterno"],
    secondLastname: json["apellidoMaterno"],
    identityDocument: json["ci"],
    phone: json["telefono"],
    email: json["correoElectronico"],
    address: json["direccion"],
  );

  Map<String, dynamic> toJson() => {
    "idPersona": id,
    "nombre": name,
    "apellidoPaterno": firstLastname,
    "apellidoMaterno": secondLastname,
    "ci": identityDocument,
    "telefono": phone,
    "correoElectronico": email,
    "dirección": address,
  };

  String getName() {
    return "$name $firstLastname ${secondLastname ?? ""}";
  }
}