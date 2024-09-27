import 'package:flutter/material.dart';
import 'package:hotel/screens/mobile/widgets/elapsed_time_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hotel/data/models/room_model.dart';

class RoomCardWidget extends StatefulWidget {

  final Room room;
  final void Function()? onTap;

  const RoomCardWidget({
    super.key,
    required this.room,
    this.onTap,
  });

  @override
  State<RoomCardWidget> createState() => _RoomCardWidgetState();
}

class _RoomCardWidgetState extends State<RoomCardWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<IconData, void Function(int)> actions = {};
    late Color bgHeader;
    switch (widget.room.state) {
      case Room.free: // free room
        actions[MdiIcons.play] = (int id) {};
        bgHeader = const Color.fromRGBO(146, 211, 110, 1);
        // actions[FluentIcons.power_button] = (int id) {};
        // actions[FluentIcons.power_standby] = (int id) {};
        // actions[FluentIcons.time_sheet] = (int id) {};
      case Room.inUse: // ocupied room
        bgHeader = const Color.fromRGBO(77, 215, 250, 1);
        // actions[MdiIcons.fanOff] = (int id) {};
        // actions[MdiIcons.hotTub] = (int id) {};
        actions[MdiIcons.accountCash] = (int id) {};
        // actions[MdiIcons.store] = (int id) {};
      case Room.dirty:
        bgHeader = const Color.fromRGBO(255, 138, 132, 1);
        actions[MdiIcons.broom] = (int id) {};
      case Room.cleaning:
        bgHeader = const Color.fromRGBO(255, 215, 131, 1);
        actions[MdiIcons.fanOff] = (int id) {};
      case Room.maintenance:
        bgHeader = const Color.fromRGBO(189, 189, 189, 1);
    }
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        color: bgHeader,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.room.name, 
                      style: const TextStyle(
                        fontSize: 25, 
                        fontWeight: FontWeight.bold,
                        height: 1.0
                      ),
                      maxLines: null,
                      // overflow: TextOverflow.fade,
                      // softWrap: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.room.state,
                          style: const TextStyle(fontSize: 20), 
                        ),
                        if (widget.room.product.time != null)
                          ElapsedTimeWidget(
                            time: widget.room.product.time!,
                            style: const TextStyle(fontSize: 20),
                          ),
                      ],
                    )
                  ],
                ),
              ),
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
      ),
    );
    // return Card(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Container(
    //         color: bgHeader,
    //         padding: const EdgeInsets.symmetric(horizontal: 5),
    //         child: Row(
    //           children: [
    //             Text(widget.room.name),
    //             const Spacer(),
    //             for(MapEntry<IconData, void Function(int)> action in actions.entries)
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 3),
    //                 child: IconButton(
    //                   icon: Icon(action.key), 
    //                   onPressed: () => action.value(widget.room.id),
    //                 ),
    //               ),
    //           ],
    //         ),
    //       ),
    //       Text(type),
    //       Text(state),
    //     ],
    //   ),
    // );
  }
}