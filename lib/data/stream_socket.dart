import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:hotel/data/homeassistant.dart';
import 'package:hotel/data/models/product_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hotel/data/env.dart';

class StreamSocket{
  final _socketResponse= StreamController<String>();
  final _homeassistant =  Homeassistant();
  final void Function(Room) updater; 
  final void Function(Product) updateDevice; 
  late IO.Socket _socket;

  StreamSocket(this.updater, this.updateDevice) ;

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
    _socket.disconnect();
    _socket.dispose();
  }

  void connectAndListen(){
    _socket = IO.io(baseURL,
      <String, dynamic> {
        'transports': ['websocket'],
      }
    );

    _socket.onConnect((_) {
     log('connected to server');
    });

    //When an event recieved from server, data is added to the stream
    // socket.on('event', (data) => addResponse);
    _socket.onDisconnect((_) => log('disconnect'));

    _socket.on("CODE-HAB", (data) {
      log("response socket");
      log("Is data json: ${(data is Map<String,dynamic>).toString()}");
      log("Data: ${data.toString()}");
      // Map<String, dynamic> result = Map.castFrom(json.decode(data));
      // final result = jsonDecode(data) as Map<String,dynamic>;
      Product product = Product.fromJson(data["habitacion"]);
      if (product.type == 2) {
        Room newRoom = Room(product: product);
        updater(newRoom);
      } else if (product.type == 3){
        updateDevice(product);      }
    });
  }
  

  // void _callHomeAssistant() async {
  //   await _homeassistant.turnOnSwitch("switch.tasmota_tasmota2");
  // }
}
