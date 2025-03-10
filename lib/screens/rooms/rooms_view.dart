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
import 'package:hotel/env.dart';
import 'package:hotel/screens/error_view.dart';
import 'package:hotel/screens/loading_view.dart';
import 'package:hotel/screens/widgets/menu_widget.dart';
import 'package:hotel/screens/widgets/room_card_widget.dart';

class RoomsView extends StatefulWidget {
  
  final Env env;
  final Login login;
  final Menu menu;
  
  const RoomsView({
    super.key, 
    required this.env,
    required this.login, 
    required this.menu, 
  });

  @override
  State<RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<RoomsView> {
  List<Room> _roomList = [];
  bool _isLoaded = false;
  bool _isConnected = false;
  Data<List<Room>>? _result;
  late RoomService roomService;
  late StreamSocket _streamSocket;
  
  void setConnection(bool val) {
    setState(() => _isConnected = val);
  }

  void updater(Room newRoom) async {
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
    roomService = RoomService(env: widget.env);
    _fetchRooms();
  }

  @override
  void dispose() {
    _streamSocket.dispose();
    super.dispose();
  }

  Future<void> _fetchRooms() async {
    log("calling api");
    _result = await roomService.getAllRooms();
    _roomList = _result!.data ?? [];
    _streamSocket = StreamSocket(widget.env, updater, updateDevice, setConnection);
    _streamSocket.connectAndListen();
    setState(() {
      log("loaded true?");
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return CustomScaffold(
    //   title: "Habitaciones", 
    //   isLoaded: _isLoaded, 
    //   data: _result, 
    //   body: _body, 
    //   menuWidget: MenuWidget(
    //     env: widget.env,
    //     login: widget.login,
    //     selectedMenuCode: widget.menu.menuCode,
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Habitaciones"),
      ),
      body: !_isLoaded ? 
        const LoadingView() 
        : _result!.data == null ? 
          ErrorView(message: _result!.message)
        : !_isConnected ?  
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ErrorView(
              message: "No se pudo establecer una conexion con el servidor. Revisar la conexión a internet.", 
              description: "La vista cargará automaticamente cuando vuelva a conectarse.",
            ),
          )
        : _body(context, false),
      drawer: MenuWidget(
        env: widget.env,
        login: widget.login,
        selectedMenuCode: widget.menu.menuCode,
      ),
    );
  }

  Widget _body(BuildContext context, bool internetConnection) {
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
                  env: widget.env,
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