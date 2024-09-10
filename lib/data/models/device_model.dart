class Device {
  final int id;
  final String name;
  final String position;
  final String productCode;
  final String serie;
  final int type;
  final bool activate;
  final bool automatic;
  final bool pulse;
  final bool state;

  Device({
    required this.id,
    required this.name,
    required this.position,
    required this.productCode,
    required this.serie,
    required this.type,
    required this.activate,
    required this.automatic, 
    required this.pulse,
    required this.state,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json["idProducto"], 
    name: json["nombreProducto"], 
    position: json["posicion"], 
    productCode: json["codigoProducto"], 
    serie: json["serie"], 
    type: json["tipo"], 
    activate: json["activado"] == 1, 
    automatic: json["automatico"] == 1, 
    pulse: json["pulso"] == 1,
    state: json["estado"] == 1,
  );

  Map<String, dynamic> toJson() => {
    "idProducto": id,
    "nombreProducto": name,
    "posicion": position,
    "codigoProducto": productCode,
    "serie": serie,
    "tipo": type,
    "activado": activate ? 1 : 0,
    "automatico": automatic ? 1 : 0,
    "pulso": pulse ? 1 : 0,
    "estado": state ? 1 : 0
  };
}