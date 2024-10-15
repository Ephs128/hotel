import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hotel/data/models/compound_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/data/models/product_model.dart';
import 'package:hotel/data/service/room_service.dart';
import 'package:hotel/screens/mobile/rooms/room_before_cleaning_view.dart';
import 'package:hotel/screens/mobile/widgets/elapsed_time_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hotel/data/models/room_model.dart';

import 'package:hotel/screens/mobile/widgets/dialogs.dart';

class RoomCardWidget extends StatefulWidget {

  final Room room;
  final Menu menu;

  const RoomCardWidget({
    super.key,
    required this.room,
    required this.menu,
  });

  @override
  State<RoomCardWidget> createState() => _RoomCardWidgetState();
}

class _RoomCardWidgetState extends State<RoomCardWidget> {
  final roomService = RoomService();
  bool reviewPermission = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    late Color bgHeader;
    reviewPermission = widget.menu.actions.containsKey("MMAARL");
    switch (widget.room.state) {
      case Room.free:
        bgHeader = const Color.fromARGB(255, 52, 195, 143);
        // if(widget.menu.actions.containsKey("MMAAHB")){
        //   buttons.add(
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 3),
        //       child: IconButton(
        //         icon: Icon(MdiIcons.play), 
        //         color: Colors.white,
        //         onPressed: () => {},
        //       ),
        //     )
        //   );
        // }
        if(reviewPermission){
          buttons.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: IconButton(
                color: Colors.white,
                icon: Icon(MdiIcons.clipboardTextSearchOutline), 
                onPressed: () => _onClickReviewFreeRoom(),
              ),
            )
          );
        }
      case Room.inUse: // ocupied room
        bgHeader = const Color.fromARGB(255, 80, 165, 241);
        // if(widget.menu.actions.containsKey("MMAARL")){ //! descomentar
          // buttons.add(
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 3),
          //     child: IconButton(
          //       icon: Icon(MdiIcons.accountCash), 
          //       color: Colors.white,
          //       onPressed: () => {},
          //     ),
          //   )
          // );
        // } //! descomentar
      case Room.dirty:
        bgHeader = const Color.fromARGB(255, 244, 106, 106);
        if(widget.menu.actions.containsKey("MMAALP")){ 
        buttons.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: IconButton(
                icon: Icon(MdiIcons.broom), 
                color: Colors.white,
                onPressed: () => _onClickDirtyRoom()
              ),
            )
          );
        } 
      case Room.cleaning:
        bgHeader = const Color.fromARGB(255, 241, 180, 76);
        if(widget.menu.actions.containsKey("MMAALP")){ 
          for(Compound compound in widget.room.product.compounds) {
            if (compound.subproduct.type == 3) { // type 3 = device
              if (compound.subproduct.productTYpe == 3) {// type 3 = fan
                bool off = compound.subproduct.activate == 0;
                buttons.add(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: IconButton(
                      icon: Icon(off ? MdiIcons.fanOff: MdiIcons.fan), 
                      onPressed: () => _onClickFan(context, compound.subproduct, off),
                      color: off? Colors.white : Colors.red,
                    ),
                  )
                );
              }
            }
          }
          buttons.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: IconButton(
                icon: Icon(MdiIcons.creation),
                color: Colors.white,
                onPressed: () => _onClickEndCleaning(),
              ),
            )
          );
        }
      case Room.maintenance:
        bgHeader = const Color.fromARGB(255, 116, 120, 141);
      case Room.outService:
        bgHeader = const Color.fromARGB(255, 52, 58, 64);
      case Room.review:
        bgHeader = const Color.fromARGB(255, 86, 74, 177);
        if(widget.menu.actions.containsKey("MMAALP") || reviewPermission ) {
          for(Compound compound in widget.room.product.compounds) {
            if (compound.subproduct.type == 3) { // type 3 = device
              if (compound.subproduct.productTYpe == 3) {// type 3 = fan
                bool off = compound.subproduct.activate == 0;
                buttons.add(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: IconButton(
                      icon: Icon(off ? MdiIcons.fanOff: MdiIcons.fan), 
                      onPressed: () => _onClickFan(context, compound.subproduct, off),
                      color: off? Colors.white : Colors.red,
                    ),
                  )
                );
              }
            }
          }
          buttons.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: IconButton(
                icon: reviewPermission ? Icon(MdiIcons.eye) : Icon(MdiIcons.broom),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomBeforeCleaningView(room: widget.room, reviewPermission: reviewPermission))),
                color: Colors.white,
              ),
            )
          );
        }
      case Room.vip:
        bgHeader = const Color.fromARGB(255, 232, 62, 140);
      default:
        bgHeader = const Color.fromARGB(255, 255, 0, 0);
    }
    return Card(
      color: bgHeader,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.room.name, 
                      style: const TextStyle(
                        fontSize: 25, 
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                        color: Colors.white,
                      ),
                      maxLines: null,
                      // overflow: TextOverflow.fade,
                      // softWrap: true,
                    ),
                  ),
                  Row(
                    children: buttons
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.room.state,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ), 
                  ),
                  if (widget.room.product.time != null)
                    ElapsedTimeWidget(
                      time: widget.room.product.time!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                ],
              )
            ],
          ), 
        ),
      ),
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(5, "0");

  Future<void> _actionRoom({required BuildContext context, required Room room, required Future<Data<String>> Function(Room) serviceAction, required void Function(String) onOk} ) async {
    showLoaderDialog(context);
    Data<String> result = await serviceAction(room);
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
      onOk(result.data!);
    }
  }

  void _onClickDirtyRoom() {
    showConfirmationDialog(
      context: context, 
      title: "¿Limpiar habitación?",
      message: "Se habilitará la cerradura y se encenderan las luces.",
      onConfirmation: () {
        _actionRoom(
          context:  context, 
          room: widget.room, 
          serviceAction: roomService.cleanRoom, 
          onOk: (optionalMessage) =>  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomBeforeCleaningView(room: widget.room, reviewPermission: reviewPermission))),
            
        );
      
      },
    );
  }

  void _onClickEndCleaning() {
    showConfirmationDialog(
      context: context, 
      title: "¿Terminar limpieza?",
      message: "Se cerrará la cerradura y se apagaran las luces. Asegurese de estar fuera de la habitación antes de continuar.",
      onConfirmation: () {
        if(widget.room.product.time != null){
          Duration elapsedTime = DateTime.now().difference(widget.room.product.time!);
          widget.room.product.actualTime = format(elapsedTime);
          log("hora actual: ${widget.room.product.actualTime}");
          _actionRoom(
            context:  context, 
            room: widget.room, 
            serviceAction: roomService.cleanFinish, 
            onOk: (optionalMessage) => showMessageDialog(context: context, title: "Bien", message: optionalMessage,),
          );
        }
      }
    );
  }

  void _onClickReviewFreeRoom() {
    showConfirmationDialog(
      context: context, 
      title: "¿Empezar revisión?",
      message: "Se habilitará la cerradura y se encenderan las luces.", 
      onConfirmation: () {
        _actionRoom(
          context:  context, 
          room: widget.room, 
          serviceAction: roomService.cleanRoom, 
          onOk: (optionalMessage) =>  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomBeforeCleaningView(room: widget.room, reviewPermission: reviewPermission,))),
        );
        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomBeforeCleaningView(room: widget.room, reviewPermission: reviewPermission)));
      }
    );
  }

  void _onClickFan(BuildContext context, Product device, bool isOff) async {
    showLoaderDialog(context);
    Data<String> result = await roomService.dispRoom(device, isOff ? 1 : 0);
    if (context.mounted) {
      closeLoaderDialog(context);
      if(result.data == null) {
        showMessageDialog(
          context: context, 
          title: "Hubo un error",
          message: result.message,
        );
      } else {
        // todo: se deberia hacer algo? o_O 
      }
    }

  }

}