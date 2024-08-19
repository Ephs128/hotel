import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/provider/login_api.dart';

class LoginService {
  final _api = LoginApi();

  Future<Data<String>> postLogin(String user, String password) async {
    return _api.postLogin(user, password);
  }
}