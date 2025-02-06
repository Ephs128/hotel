import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/data/provider/menu_api.dart';
import 'package:hotel/env.dart';

class MenuService{

  final Env env;
  late MenuApi _api;

  MenuService({required this.env}) {
    _api = MenuApi(env: env);
  }
  
  Future<Data<List<Menu>>> getAllMenus() async {
    return _api.getAllMenus();
  }
}