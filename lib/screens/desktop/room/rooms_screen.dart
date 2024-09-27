import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/service/room_service.dart';
import 'package:hotel/data/stream_socket.dart';
import 'package:hotel/screens/desktop/widgets/room_card_widget.dart';
import 'package:responsive_grid/responsive_grid.dart';

class RoomsScreen extends StatefulWidget {

  final Function(Widget) changeScreenTo;
  final String? withSuccessMessage;
  final String? withErrorMessage;

  const RoomsScreen({
    super.key, 
    required this.changeScreenTo, 
    this.withSuccessMessage, 
    this.withErrorMessage,
  });

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<Room> _roomList = [];
  bool _isLoaded = false;
  Data<List<Room>>? _result;
  late StreamSocket _streamSocket;
  final RoomService roomService = RoomService();
  
  void updater(Room newRoom) {
    final idx = _getIndexFrom(newRoom);
    if(idx < _roomList.length) {
      setState(() {
        _roomList[idx] = newRoom;
      });
    }
  }

  int _getIndexFrom(Room newRoom) {
    int i = 0;
    for(Room room in _roomList) {
      if (room.id == newRoom.id) {
        break;
      }
      i++;
    }
    return i;
  }

  @override
  void initState() {
    super.initState();
    _streamSocket = StreamSocket(updater);
    _streamSocket.connectAndListen();
    _fetchRooms();
  }

  @override
  void dispose() {
    _streamSocket.dispose();
    super.dispose();
  }

  Future<void> _fetchRooms() async {
    _result = await roomService.getAllRooms();
    _roomList = _result!.data ?? [];
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ResponsiveGridList(
        desiredItemWidth: 200,
        minSpacing: 20,
        children: _roomList.map((Room room) =>
          RoomCardWidget(
            room: room,
            changeScreenTo: widget.changeScreenTo,
            roomService: roomService,
          ),
        ).toList(),
      ),
    );
  }
}
