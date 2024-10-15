class Promo {

  final int id;
  final String details;
  final String price;
  final int time;
  final bool state;

  Promo({
    required this.id,
    required this.details,
    required this.price,
    required this.time,
    required this.state,
  });

  factory Promo.fromJson(Map<String, dynamic> json) => Promo(
    id: json["idPromocion"], 
    details: json["detalle"], 
    price: json["precio"], 
    time: json["tiempo"], 
    state: json["estado"] == 1, 
  );

  Map<String, dynamic> toJson() => {
    "idPromocion": id, 
    "detalle": details, 
    "precio": price, 
    "tiempo": time, 
    "estado": state ? 1 : 0, 
  };

}