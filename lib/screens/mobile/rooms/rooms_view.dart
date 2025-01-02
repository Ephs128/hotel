import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hotel/data/models/compound_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/data/models/product_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/service/room_service.dart';
import 'package:hotel/data/stream_socket.dart';
import 'package:hotel/screens/mobile/error_view.dart';
import 'package:hotel/screens/mobile/loading_view.dart';
import 'package:hotel/screens/mobile/widgets/menu_widget.dart';
import 'package:hotel/screens/mobile/widgets/room_card_widget.dart';

class RoomsView extends StatefulWidget {
  
  final Login login;
  final Menu menu;
  
  const RoomsView({
    super.key, 
    required this.login, 
    required this.menu, 
  });

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
      log("updated room");
      setState(() {
        _roomList[idx].update(newRoom);
      });
    }
  }

  void updateDevice(Product device) {
    bool found = false;
    for(Room room in _roomList) {
      for (Compound compound in room.product.compounds) {
        found = compound.subproduct!.idProduct == device.idProduct;
        if(found) {
          setState(() {
            compound.subproduct = device;
          });
          break;
        }
      }
      if (found) {
        break;
      }
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
    _streamSocket = StreamSocket(updater,updateDevice);
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
      drawer: MenuWidget(
        login: widget.login,
        selectedMenuCode: widget.menu.menuCode,
      ),
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: () {
        setState(() {
          _isLoaded = false;
        });
        _fetchRooms();
        return Future.value(true);
      },
      child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: _roomList.map((room) {
                return RoomCardWidget(
                  room: room, 
                  menu: widget.menu,
                  login: widget.login,
                  roomList: _roomList,
                );
              }).toList(),
            ),
          ),
        ),
    );
  }

  // Widget _whenErrorHappens() {
  //   if (_result!.statusCode == 401) {
  //     return Loggin
  //   }
  // }
}