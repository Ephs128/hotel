import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/data/provider/role_api.dart';
import 'package:hotel/env.dart';

class RoleService {

  final Env env;
  late RoleApi _api;

  RoleService({required this.env}) {
    _api = RoleApi(env: env);
  }

  Future<Data<List<Role>>> getAllRoles() async {
    return _api.getAllRoles();
  }
}