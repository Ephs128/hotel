import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/data/provider/menu_api.dart';

class MenuService{
  final _api = MenuApi();
  
  Future<Data<List<Menu>>> getAllMenus() async {
    return _api.getAllMenus();
  }
}