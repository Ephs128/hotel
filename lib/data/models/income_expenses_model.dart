import 'package:hotel/data/models/promo_model.dart';
import 'package:intl/intl.dart';

class IncomeExpenses {
  int? id;
  double amountCharged;
  double amountTransfer;
  double amountQr;
  double amountCash;
  String date;
  String time;
  String description;
  int type;
  int idCashbox;
  int idSale;
  int payType;
  bool promo;
  int idPromo;
  final dateFormat = DateFormat('yyyy-MM-dd');
  final timeFormat = DateFormat('hh:mm:ss');

  IncomeExpenses ({
    this.id,
    required this.amountCharged,
    required this.amountTransfer,
    required this.amountQr,
    required this.amountCash,
    required this.date,
    required this.time,
    required this.description,
    required this.type,
    required this.idCashbox,
    required this.idSale,
    required this.payType,
    required this.promo,
    required this.idPromo,
  });

  factory IncomeExpenses.fromJson(Map<String, dynamic> json) => IncomeExpenses(
    id: json["idIngresoEgreso"], 
    amountCharged: json["monto"], 
    amountTransfer: json["montoT"], 
    amountQr: json["montoQ"], 
    amountCash: json["montoE"], 
    date: json["fecha"], 
    time: json["hora"],
    description: json["descripcion"], 
    type: json["tipo"], 
    idCashbox: json["idCaja"], 
    idSale: json["idVenta"], 
    payType: json["tipoPago"], 
    promo: json["esPromo"], 
    idPromo: json["idPromocion"],
  );

  Map<String, dynamic> toJson() => {
    if(id != null ) "idIngresoEgreso": id, 
    "monto": amountCharged,
    "montoT": amountTransfer,
    "montoQ": amountQr,
    "montoE":amountCash, 
    "fecha": date,
    "hora": time,
    "descripcion": description,
    "tipo": type,
    "idCaja": idCashbox,
    "idVenta": idSale,
    "tipoPago": payType,
    "esPromo": promo,
    "idPromocion": idPromo,
  }; 
}