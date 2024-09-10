import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/room_model.dart';

class RoomApi {

  Future<Data<List<Room>>> getAllRooms() async {
    return Data<List<Room>>(data: null);
  }

}