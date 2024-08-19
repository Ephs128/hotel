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
    id: json["idPerson"],
    name: json["name"],
    firstLastname: json["firstLastname"],
    secondLastname: json["secondLastname"],
    identityDocument: json["dni"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "idPerson": id,
    "name": name,
    "firstLastname": firstLastname,
    "secondLastname": secondLastname,
    "ci": identityDocument,
    "phone": phone,
    "email": email,
    "address": address,
  };

  String getName() {
    return "$name $firstLastname ${secondLastname ?? ""}";
  }
}