import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/income_expenses_model.dart';
import 'package:hotel/data/models/promo_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/models/sale_model.dart';
import 'package:hotel/data/models/sale_product_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/provider/pay_api.dart';
import 'package:hotel/env.dart';

class PayService {
  
  final Env env;
  late PayApi _api;

  PayService({required this.env}) {
    _api = PayApi(env: env);
  }

  Future<Data<String>> prePay (
    String time, 
    Room room,
    double roomAmountCharged,
    double amountCharged, 
    User user,
    int selectedOption,
    double amountCash,
    double amountTransfer,
    double amountQr,
    String description,
    int idCashbox,
    Promo? selectedPromo,
  ) async {
    return _api.prePay(time, room, roomAmountCharged, amountCharged, user, selectedOption, amountCash, amountTransfer, amountQr, description, idCashbox, selectedPromo);
  }

  Future<Data<String>> pay (
    Room room
  ) async {
    return _api.pay(room);
  }
}