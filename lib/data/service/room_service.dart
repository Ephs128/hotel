import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/provider/room_api.dart';

class RoomService {
  final _api = RoomApi();
  Future<Data<List<Room>>> getAllRooms() async {
    return _api.getAllRooms();
  }
}