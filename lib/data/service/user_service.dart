import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/provider/user_api.dart';

class UserService {
  final _api = UserApi();
  Future<Data<List<User>>> getAllUsers() async {
    return _api.getAllUsers();
  }
}