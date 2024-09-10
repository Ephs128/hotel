class Cashbox {
  final int id;
  final String name;
  final String amount;
  final String virtualAmount;
  final String? numberAccount;
  final bool state;

  Cashbox({
    required this.id,
    required this.name,
    required this.amount,
    required this.virtualAmount,
    this.numberAccount,
    required this.state,
  });

  factory Cashbox.fromJson(Map<String, dynamic> json) => Cashbox(
    id: json["idCaja"],
    name: json["nombreCaja"],
    amount: json["monto"],
    virtualAmount: json["montoVirtual"],
    numberAccount: json["numeroCuenta"],
    state: json["estado"] == 1,
  );

  Map<String, dynamic> toJson() => {
    "idCaja": id,
    "nombreCaja": name,
    "monto": amount,
    "montoVirtual": virtualAmount,
    "numeroCuenta": numberAccount,
    "estado": state ? 1 : 0,
  };

  @override
  String toString() {
    return name;
  }
}