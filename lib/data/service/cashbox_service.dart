import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/provider/cashbox_api.dart';

class CashboxService{
  
  final _api = CashboxApi();
  
  Future<Data<List<Cashbox>>> getAllCashboxes() async {
    return _api.getAllCashboxes();
  }
  
  Future<Data<String>> createCashbox(String cashboxName, String? amount, String? virtualAmount, String? numberAccount) async {
    return _api.createCashbox(cashboxName, amount, virtualAmount, numberAccount);
  }

  Future<Data<String>> updateCashbox(Cashbox cashbox) async {
    return _api.updateCashbox(cashbox);
  }

  Future<Data<String>> deleteCashbox(Cashbox cashbox) async {
    return _api.deleteCashbox(cashbox);
  }
}