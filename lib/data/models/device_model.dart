class Device {
  final int id;
  final String name;
  final String? decription;
  final String position;
  final String productCode;
  final String? measure;
  final String serie;
  final int type;
  final bool activate;
  final String purchasePrice;
  final String salePrice;
  final bool state;

  Device({
    required this.id,
    required this.name,
    this.decription,
    required this.position,
    required this.productCode, 
    this.measure,
    required this.serie,
    required this.type,
    required this.activate,
    required this.purchasePrice,
    required this.salePrice,
    required this.state,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json["idProduct"], 
    name: json["productName"], 
    decription: json["description"],
    position: json["position"], 
    productCode: json["productCode"], 
    measure: json["measure"],
    serie: json["serie"], 
    type: json["type"], 
    activate: json["activate"] == 1, 
    purchasePrice: json["purchasePrice"], 
    salePrice: json["salePrice"], 
    state: json["state"] == 1, 
  );

  Map<String, dynamic> toJson() => {
    "idProduct": id,
    "productName": name,
    "description": decription,
    "position": position,
    "productCode": productCode,
    "measure": measure,
    "serie": serie,
    "type": type,
    "activate": activate,
    "purchasePrice": purchasePrice,
    "salePrice": salePrice,
    "state": state,
  };
}