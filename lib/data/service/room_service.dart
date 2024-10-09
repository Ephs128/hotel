import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/models/room_state_model.dart';
import 'package:hotel/data/provider/room_api.dart';

class RoomService {
  final _api = RoomApi();
  
  Future<Data<List<Room>>> getAllRooms() async {
    return _api.getAllRooms();
  }

  Future<Data<String>> enableRoom(Room room) async {
    return _api.enableRoom(room);
  }

  Future<Data<String>> dispRoom(Room room) async {
    return _api.dispRoom(room);
  }

  Future<Data<String>> cleanRoom(Room room) async {
    // room.product.time = DateTime.now();
    room.product.activate = 6;
    return _api.cleanRoom(room);
  }

  Future<Data<String>> cleanStart(RoomState room) async {
    return _api.cleanStart(room);
  }

  Future<Data<String>> changeRoom(Room room1, Room room2) async {
    return _api.changeRoom(room1, room2);
  }

  Future<Data<String>> cleanFinish(Room room) async {
    return _api.cleanFinish(room);
  }
}