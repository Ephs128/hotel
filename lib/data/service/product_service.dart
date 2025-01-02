import 'package:hotel/data/models/category_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/sale_product_model.dart';
import 'package:hotel/data/models/store_product_model.dart';
import 'package:hotel/data/provider/product_api.dart';

class ProductService {
  final _api = ProductApi();

  Future<Data<List<StoreProduct>>> getAllProductsIn(int idStore) async {
    return _api.getAllProducts(idStore);
  }
  
  Future<Data<List<Category>>> getProductsAvailables() async {
    return _api.getProductsAvailables();  
  }

  Future<Data<List<SaleProduct>>> getProductsInSale(int idSale) async {
    return _api.getProductsInSale(idSale);
  }

  Future<Data<String>> deleteProductInSale(SaleProduct saleProduct) async {
    return _api.deleteProductInSale(saleProduct);
  }
}