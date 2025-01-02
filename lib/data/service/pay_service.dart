import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/promo_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/provider/pay_api.dart';

class PayService {
  final PayApi _api = PayApi();

  Future<Data<String>> postPay (
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
    return _api.postPay(time, room, roomAmountCharged, amountCharged, user, selectedOption, amountCash, amountTransfer, amountQr, description, idCashbox, selectedPromo);
  }
}