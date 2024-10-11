import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/provider/login_api.dart';

class LoginService {
  final _api = LoginApi();

  Future<Data<Login>> postLogin(String user, String password) async {
    return _api.postLogin(user, password);
  }

  Future<Data<String>> postLogout (User user) async {
    return _api.postLogout(user);
  }
}