import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/service/room_service.dart';
import 'package:hotel/data/stream_socket.dart';
import 'package:hotel/screens/mobile/error_view.dart';
import 'package:hotel/screens/mobile/rooms/room_cleaning.dart';
import 'package:hotel/screens/mobile/loading_view.dart';
import 'package:hotel/screens/mobile/widgets/menu_widget.dart';
import 'package:hotel/screens/mobile/widgets/room_card_widget.dart';

import 'package:hotel/screens/mobile/widgets/dialogs.dart';

class RoomsView extends StatefulWidget {
  const RoomsView({super.key});

  @override
  State<RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<RoomsView> {
  List<Room> _roomList = [];
  bool _isLoaded = false;
  Data<List<Room>>? _result;
  final roomService = RoomService();
  late StreamSocket _streamSocket;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habitaciones"),
      ),
      body: !_isLoaded ? 
        const LoadingView() : 
        _result!.data == null ?
        ErrorView(message: _result!.message)
        : body(),
      drawer: const MenuWidget(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
        child: Column(
          children: _roomList.map((room) {
            void Function() onTap;
            switch(room.state) {
              case Room.free:
                onTap = () => showConfirmationDialog(
                  context: context, 
                  title: "¿Habilitar habitación?",
                  message: "Se habilitará la cerradura y se encenderan las luces",
                  onConfirmation: () {
                    actionRoom(context, room, roomService.enableRoom);
                  }
                );
              case Room.inUse:
                onTap = () => showMessageDialog(context: context, message: "No tienes permiso para ver esta habitación");
              case Room.dirty:
                onTap = () { 
                  showConfirmationDialog(
                    context: context, 
                    title: "¿Limpiar habitación?",
                    message: "Se habilitará la cerradura y se encenderan las luces",
                    onConfirmation: () {
                      actionRoom(context, room, roomService.cleanRoom);
                      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomCleaning(room: room)));
                    },);
                };
              case Room.cleaning:
                onTap = () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomCleaning(room: room)));
              case Room.maintenance:
                onTap = () => showMessageDialog(context: context, message: "No tienes permiso para ver esta habitación");
              default:
                onTap = () => showMessageDialog(context: context, message: "Surgio un error, estado de habitacion no válido");
            }
            return RoomCardWidget(
              room: room, 
              onTap: onTap,
            );
          }).toList(),
        ),
      );
  }

  Future<void> actionRoom(BuildContext context, Room room, Future<Data<String>> Function(Room) action ) async {
    showLoaderDialog(context);
    Data<String> result = await action(room);
    if (context.mounted) closeLoaderDialog(context);
    if (result.data == null) {
      if (context.mounted) {
        showMessageDialog(
          context: context, 
          title: "Error",
          message: result.message
        );
      }
    } else {
      if (context.mounted) {
        showMessageDialog(
          context: context, 
          title: "Bien",
          message: result.data!
        );
      }
    }
  }
}