import 'package:hotel/data/models/aux_sale_product_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/sale_model.dart';
import 'package:hotel/data/models/sale_product_model.dart';
import 'package:hotel/data/provider/sale_api.dart';
import 'package:hotel/env.dart';

class SaleService {

  final Env env;
  late SaleApi _api;

  SaleService({required this.env}) {
    _api = SaleApi(env: env);
  }

  Future<Data<Sale>> getSale(int idSale) async {
    return _api.getSale(idSale);
  }

  Future<Data<String>> createSale(List<SaleProduct> saleProducts, List<AuxSaleProduct> newSaleProducts ) async {
    return _api.createSale(saleProducts, newSaleProducts);
  }
}