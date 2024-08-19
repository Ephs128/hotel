import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/store_model.dart';
import 'package:hotel/data/provider/store_api.dart';

class StoreService {
  final _api = StoreApi();
  Future<Data<List<Store>>> getAllStores() {
    return _api.getAllStores();
  }
}