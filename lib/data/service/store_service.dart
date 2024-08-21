import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/store_model.dart';
import 'package:hotel/data/provider/store_api.dart';

class StoreService {
  final _api = StoreApi();
  Future<Data<List<Store>>> getAllStores() {
    return _api.getAllStores();
  }

  Future<Data<String>> createStore(String storeName) async {
    return _api.createStore(storeName);
  }

  Future<Data<String>> updateStore(Store store) async {
    return _api.updateStore(store);
  }

  Future<Data<String>> deleteStore(Store store) async {
    return _api.deleteStore(store);
  }
}