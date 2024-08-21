import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/device_model.dart';
import 'package:hotel/data/provider/device_api.dart';

class DeviceService {
  final _api = DeviceApi();
  Future<Data<List<Device>>> getAllDevices() {
    return _api.getAllDevices();
  }

  Future<Data<String>> createDevice(String productName, String position, String productCode, String serie, int type, bool activate) async {
    return _api.createDevice(productName, position, productCode, serie, type, activate);
  }

  Future<Data<String>> updateDevice(Device device) async {
    return _api.updateDevice(device);
  }

  Future<Data<String>> deleteDevice(Device device) async {
    return _api.deleteDevice(device);
  }
}