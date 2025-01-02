import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/service/room_service.dart';
import 'package:hotel/screens/desktop/room/room_store_screen.dart';
import 'package:hotel/screens/desktop/widgets/elapsed_time_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hotel/data/models/room_model.dart';

import 'package:hotel/screens/desktop/widgets/dialog_functions.dart';

class RoomCardWidget extends StatefulWidget {

  final Room room;
  final Function(Widget) changeScreenTo;
  final RoomService roomService;

  const RoomCardWidget({
    super.key,
    required this.room, 
    required this.changeScreenTo,
    required this.roomService,
  });

  @override
  State<RoomCardWidget> createState() => _RoomCardWidgetState();
}

class _RoomCardWidgetState extends State<RoomCardWidget> {
  late String type;
  late Color bgHeader;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<IconData, void Function(int)> actions = {};
    switch (widget.room.statename) {
      case Room.free: // free room
        actions[FluentIcons.m_s_n_videos] = (int id) {
          showConfirmationDialog(
            context, 
            "¿Habilitar habitación?",
            "Se habilitará la cerradura y se encenderan las luces",
            () => actionRoom(context, widget.room, widget.roomService.enableRoom)
          );
        };
        bgHeader = const Color.fromRGBO(146, 211, 110, 1);
        // actions[FluentIcons.power_button] = (int id) {};
        // actions[FluentIcons.power_standby] = (int id) {};
        // actions[FluentIcons.time_sheet] = (int id) {};
      case Room.inUse: // ocupied room
        bgHeader = const Color.fromRGBO(77, 215, 250, 1);
        actions[MdiIcons.fanOff] = (int id) {};
        actions[MdiIcons.hotTub] = (int id) {};
        actions[MdiIcons.accountCash] = (int id) {};
        actions[MdiIcons.store] = (int id) {
          widget.changeScreenTo(RoomStoreScreen(
            changeScreenTo: widget.changeScreenTo, 
            room: widget.room)
          );
        };
      case Room.dirty:
        bgHeader = const Color.fromRGBO(255, 138, 132, 1);
        actions[MdiIcons.sprayBottle] = (int id) {
          showConfirmationDialog(
          context, 
          "¿Limpiar habitación?",
          "Se habilitará la cerradura y se encenderan las luces",
          () {
            actionRoom(context, widget.room, widget.roomService.cleanRoom);
            // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomCleaning(room: room)));
          },);
        };
      case Room.cleaning:
        bgHeader = const Color.fromRGBO(255, 215, 131, 1);
        actions[MdiIcons.fanOff] = (int id) {};
      case Room.maintenance:
        bgHeader = const Color.fromRGBO(189, 189, 189, 1);
    }
    return Card(
      padding: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: bgHeader,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.room.name,
                      maxLines: null,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      for(MapEntry<IconData, void Function(int)> action in actions.entries)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: IconButton(
                            icon: Icon(action.key), 
                            onPressed: () => action.value(widget.room.id),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
            // Text(widget.room.type),
            const SizedBox(height: 30,),
            Text(widget.room.statename),
            if (widget.room.product.time != null)
              ElapsedTimeWidget(
                time: widget.room.product.time!,
                style: const TextStyle(fontSize: 20),
              ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  Future<void> actionRoom(BuildContext context, Room room, Future<Data<String>> Function(Room) action ) async {
    showLoaderDialog(context);
    Data<String> result = await action(room);
    if (context.mounted) closeLoaderDialog(context);
    if (result.data == null) {
      if (context.mounted) {
        showInfoDialog(
          context, 
          "Error",
          result.message
        );
      }
    } else {
      if (context.mounted) {
        showInfoDialog(
          context, 
          "Bien",
          result.data!
        );
      }
    }
  }
}