import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/device_model.dart';
import 'package:hotel/data/provider/device_api.dart';
import 'package:hotel/env.dart';

class DeviceService {
  
  final Env env;
  late DeviceApi _api;

  DeviceService({required this.env}) {
    _api = DeviceApi(env: env);
  }
  
  Future<Data<List<Device>>> getAllDevices() {
    return _api.getAllDevices();
  }

  Future<Data<String>> createDevice(String productName, String position, String productCode, String serie, int type, bool automatic, bool pulse) async {
    return _api.createDevice(productName, position, productCode, serie, type, automatic, pulse);
  }

  Future<Data<String>> updateDevice(Device device) async {
    return _api.updateDevice(device);
  }

}