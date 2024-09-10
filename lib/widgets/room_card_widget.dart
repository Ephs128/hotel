import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/room/room_store_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hotel/data/models/room_model.dart';

class RoomCardWidget extends StatefulWidget {

  final Room room;
  final int state; // ! eliminar esto, es solo para prueba
  final Function(Widget) changeScreenTo;

  const RoomCardWidget({
    super.key,
    required this.room,
    required this.state, required this.changeScreenTo,
  });

  @override
  State<RoomCardWidget> createState() => _RoomCardWidgetState();
}

class _RoomCardWidgetState extends State<RoomCardWidget> {
  final Map<IconData, void Function(int)> actions = {};
  late String type;
  late String state;
  late Color bgHeader;

  @override
  void initState() {
    super.initState();
    switch (widget.state) {
      case 0: // free room
        state = "Libre";
        actions[FluentIcons.m_s_n_videos] = (int id) {};
        bgHeader = const Color.fromRGBO(146, 211, 110, 1);
        // actions[FluentIcons.power_button] = (int id) {};
        // actions[FluentIcons.power_standby] = (int id) {};
        // actions[FluentIcons.time_sheet] = (int id) {};
      case 1: // ocupied room
        state = "Ocupado";
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
      case 2:
        state = "Sucio";
        bgHeader = const Color.fromRGBO(255, 138, 132, 1);
        actions[MdiIcons.sprayBottle] = (int id) {};
      case 3:
        state = "En limpieza";
        bgHeader = const Color.fromRGBO(255, 215, 131, 1);
        actions[MdiIcons.fanOff] = (int id) {};
      case 4:
        state = "En mantenimiento";
        bgHeader = const Color.fromRGBO(189, 189, 189, 1);
    }
    switch (widget.room.type) {
      case 0:
        type = "Normal";
      case 1:
        type = "VIP";
      case 2:
        type = "Temático";
      default:
        type = "Incorrect Type";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: bgHeader,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Text(widget.room.name),
                const Spacer(),
                for(MapEntry<IconData, void Function(int)> action in actions.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: IconButton(
                      icon: Icon(action.key), 
                      onPressed: () => action.value(widget.room.id),
                    ),
                  ),
              ],
            ),
          ),
          Text(type),
          Text(state),
        ],
      ),
    );
  }
}