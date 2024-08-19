import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/provider/cashbox_api.dart';

class CashboxService{
  final _api = CashboxApi();
  Future<Data<List<Cashbox>>> getAllCashboxes() async {
    return _api.getAllCashboxes();
  }
}