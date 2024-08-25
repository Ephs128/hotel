import 'dart:async';
import 'dart:developer';
import 'package:hotel/data/homeassistant.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hotel/data/env.dart';

class StreamSocket{
  final _socketResponse= StreamController<String>();
  final _homeassistant =  Homeassistant();
  late IO.Socket _socket;

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
      _callHomeAssistant();
      log(data.toString());
    });
  }

  void _callHomeAssistant() async {
    await _homeassistant.turnOnSwitch("switch.tasmota_tasmota2");
  }
}
