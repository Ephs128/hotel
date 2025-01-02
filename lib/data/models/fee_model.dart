class Fee {

  final int id;
  final String detail;
  final String amount;
  final int time;
  final String additionalMount;
  final int additionalTime;
  final String additionalMount1;
  final int additionalTime1;
  final int type;
  final bool state;

  Fee({
    required this.id,
    required this.detail,
    required this.amount,
    required this.time,
    required this.additionalMount,
    required this.additionalTime,
    required this.additionalMount1,
    required this.additionalTime1,
    required this.type,
    required this.state,
  });

  factory Fee.fromJson(Map<String, dynamic> json) => Fee(
    id: json["idPrecio"],
    detail: json["detalle"],
    amount: json["monto"],
    time: json["tiempo"],
    additionalMount: json["montoAdicional"],
    additionalTime: json["tiempoAdicional"],
    additionalMount1: json["montoAdicional1"],
    additionalTime1: json["tiempoAdicional1"],
    type: json["tipo"],
    state: json["estado"] == 1,
  );

  Map<String, dynamic> toJson() => {
    "idPrecio": id,
    "detalle": detail,
    "monto": amount,
    "tiempo": time,
    "montoAdicional": additionalMount,
    "tiempoAdicional": additionalTime,
    "montoAdicional1": additionalMount1,
    "tiempoAdicional1": additionalTime1,
    "tipo": type,
    "estado":  state? 1 : 0,
  };
}