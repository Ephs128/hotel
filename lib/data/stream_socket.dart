import 'dart:async';
import 'dart:convert';

import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/product_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/env.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StreamSocket{
  final _socketResponse= StreamController<String>();
  final void Function(Room) updater; 
  final void Function(Product) updateDevice; 
  final void Function(bool) setConnection;
  final Env env;
  late IO.Socket _socket;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool _isDisposing = false;

  StreamSocket(
    this.env, 
    this.updater, 
    this.updateDevice,
    this.setConnection,
  ) ;

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose(){
    _isDisposing = true;
    _socketResponse.close();
    _socket.disconnect();
    _socket.dispose();
  }

  void connectAndListen(){
    _isDisposing = false;
    _socket = IO.io(
      env.baseUrl,
      IO.OptionBuilder().setTransports(['websocket']).enableForceNew().build()
    );

    _socket.onConnect((_) {
      log('connected to server');
      setConnection(true);
    });

    //When an event recieved from server, data is added to the stream
    // socket.on('event', (data) => addResponse);
    _socket.onDisconnect((_) { 
      log('disconnect');
      if (!_isDisposing) setConnection(false);
    });

    _socket.on("CODE-HAB", (data) {
      log("response socket");
      log("Is data json: ${(data is Map<String,dynamic>).toString()}");
      log("Data: ${data.toString()}");
      // Map<String, dynamic> result = Map.castFrom(json.decode(data));
      // final result = jsonDecode(data) as Map<String,dynamic>;
      Product product = Product.fromJson(data["habitacion"]);
      if (product.type == 2) {
        Room newRoom = Room(product: product);
        if (data["habitacion"]["esCobro"] != null) {
          _updateStorage(data["habitacion"]["esCobro"], data, newRoom.id);
        }
        updater(newRoom);
      } else if (product.type == 3){
        updateDevice(product);      
      }
      if (data["habitacion1"] != null) {
        Product product1 = Product.fromJson(data["habitacion1"]);
        if (product1.type == 2) {
          Room newRoom = Room(product: product1);
          updater(newRoom);
        } 
      }
    });
  }
  
  void _updateStorage(int charge, Map<String, dynamic> data, int roomId) {
    if (charge == 1) {
      Map<String,dynamic> json = data["data"];
      json.remove("habitacion");
      storage.write(key: "room_$roomId", value: jsonEncode(json));
    } else if (charge == 2) {
      storage.delete(key: "room_$roomId");
    }
  }
  // void _callHomeAssistant() async {
  //   await _homeassistant.turnOnSwitch("switch.tasmota_tasmota2");
  // }
}
