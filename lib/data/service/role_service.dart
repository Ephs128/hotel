import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/data/provider/role_api.dart';

class RoleService {
  final _api = RoleApi();
  Future<Data<List<Role>>> getAllRoles() async {
    return _api.getAllRoles();
  }
}