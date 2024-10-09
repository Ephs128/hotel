import 'package:hotel/data/models/product_cleanning_model.dart';
import 'package:intl/intl.dart';

class RoomState {
  int? id;
  int activate;
  DateTime? datetime;
  final String elapsedTime;
  final String? detail;
  final int idRoom;
  final int type;
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  List<ProductCleanning> productsCleanning = [];

  RoomState({
    this.id,
    this.activate = 3,
    this.datetime,
    this.detail,
    this.elapsedTime = "00:00:00",
    required this.idRoom,
    required this.type,
    productsCleanning,
  }) {
    datetime ??= DateTime.now();
    this.productsCleanning = productsCleanning ?? [];
  }

  Map<String,dynamic> toJson() => {
    if(id != null) "idEstadoHabitacion": id!,
    "activado": activate,
    "tiempo": elapsedTime, 
    if(datetime != null) "hora": dateFormat.format(datetime!),
    "detalle": detail ?? "",
    "idHabitacion": idRoom,
    "tipo": type,//1=limpieza rapida, 2=limpieza normal, 3=limpieza exhaustiva
    "limpiezaProductos": productsCleanning.map((productC) => productC.toJson()).toList()
  };

}