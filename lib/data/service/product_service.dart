import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/store_product_model.dart';
import 'package:hotel/data/provider/product_api.dart';

class ProductService {
  final _api = ProductApi();

  Future<Data<List<StoreProduct>>> getAllProductsIn(int idStore) async {
    return _api.getAllProducts(idStore);
  }
  
}