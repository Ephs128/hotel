import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/product_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/models/room_state_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/provider/room_api.dart';
import 'package:hotel/env.dart';

class RoomService {

  final Env env;
  late RoomApi _api;

  RoomService({required this.env}) {
    _api = RoomApi(env: env);
  }
  
  Future<Data<List<Room>>> getAllRooms() async {
    return _api.getAllRooms();
  }

  Future<Data<String>> enableRoom(Room room) async {
    return _api.enableRoom(room);
  }

  Future<Data<String>> dispRoom(Product product, int activate) async {
    return _api.dispRoom(product, activate);
  }

  Future<Data<String>> cleanRoom(Room room, {int activate = 6, User? user}) async {
    return _api.cleanRoom(room, activate, user);
  }

  Future<Data<String>> cleanStart(RoomState room) async {
    return _api.cleanStart(room);
  }

  Future<Data<String>> changeRoom(Room room1, Room room2) async {
    return _api.changeRoom(room1, room2);
  }

  Future<Data<String>> cancelRoom(Room room) async {
    return _api.cancelRoom(room);
  }

  Future<Data<String>> cleanFinish(Room room) async {
    return _api.cleanFinish(room);
  }

  Future<Data<String>> generateReport(RoomState room) async {
    return _api.generateReport(room);
  }
}