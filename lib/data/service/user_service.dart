import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/data/models/store_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/provider/user_api.dart';

class UserService {
  final _api = UserApi();
  Future<Data<List<User>>> getAllUsers() async {
    return _api.getAllUsers();
  }

  Future<Data<String>> createUser(String name, 
    String firstLastname, 
    String secondLastname,
    String dni,
    String phone,
    String email,
    String address,
    String user,
    String password,
    String photo,
    String thumbnail,
    Role role,
    List<Cashbox> listCashboxes,
    List<Store> listStores) async {
    return _api.createUser(name, firstLastname, secondLastname, dni, phone, email, address, user, password, photo, thumbnail, role, listCashboxes, listStores);
  }
}