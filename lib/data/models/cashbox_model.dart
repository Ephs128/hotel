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
    id: json["idCashbox"],
    name: json["cashboxName"],
    amount: json["amount"],
    virtualAmount: json["virtualAmount"],
    numberAccount: json["numberAccount"],
    state: json["state"] == 1,
  );

  Map<String, dynamic> toJson() => {
    "idCashbox": id,
    "cashboxName": name,
    "amount": amount,
    "virtualAmount": virtualAmount,
    "numberAccount": numberAccount,
    "state": state ? 1 : 0,
  };
}