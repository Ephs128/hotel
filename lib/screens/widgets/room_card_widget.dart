// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hotel/data/models/compound_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/data/models/product_model.dart';
import 'package:hotel/data/service/room_service.dart';
import 'package:hotel/env.dart';
import 'package:hotel/screens/rooms/pay_view.dart';
import 'package:hotel/screens/rooms/room_before_cleaning_view.dart';
import 'package:hotel/screens/store/store_view.dart';
import 'package:hotel/screens/widgets/elapsed_time_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hotel/data/models/room_model.dart';

import 'package:hotel/screens/widgets/dialogs.dart';

class RoomCardWidget extends StatefulWidget {

  final Env env;
  final Room room;
  final Menu menu;
  final Login login;
  final List<Room> roomList;

  const RoomCardWidget({
    super.key,
    required this.env,
    required this.room,
    required this.menu,
    required this.login,
    required this.roomList,
  });

  @override
  State<RoomCardWidget> createState() => _RoomCardWidgetState();
}

class _RoomCardWidgetState extends State<RoomCardWidget> {
  late RoomService roomService = RoomService(env: widget.env);
  bool reviewPermission = false;
  bool actionsVisible = true;
  Room? _selectedRoom;

  @override
  void initState() {
    super.initState();
    if (widget.room.product.time != null && widget.room.product.type == 1) {
      Duration elapsedTime = DateTime.now().difference(widget.room.product.time!);
      actionsVisible = elapsedTime.inMinutes <= 10;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    late Color bgHeader;
    reviewPermission = widget.menu.actions.containsKey("MMAARL");
    switch (widget.room.statename) {
      case Room.free:
        bgHeader = const Color.fromARGB(255, 52, 195, 143);
        if(widget.menu.actions.containsKey("MMAAHB")){
          buttons.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: IconButton(
                icon: Icon(MdiIcons.play), 
                color: Colors.white,
                onPressed: () => _onClickEnableRoom(),
              ),
            )
          );
        }
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
        if(widget.menu.actions.containsKey("MMAAHB")){ //! descomentar
          if(actionsVisible){
            buttons.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: IconButton(
                  icon: Icon(MdiIcons.cancel), 
                  color: Colors.white,
                  onPressed: () => _onClickCancelRoom(),
                ),
              )
            );
            buttons.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: IconButton(
                  icon: Icon(MdiIcons.cached), 
                  color: Colors.white,
                  onPressed: () => _onClickChangeRoom(),
                ),
              )
            );
          }
          buttons.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: IconButton(
                icon: Icon(MdiIcons.accountCash), 
                color: Colors.white,
                onPressed: () => _onClickChargeRoom(),
              ),
            )
          );
          buttons.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: IconButton(
                icon: Icon(MdiIcons.store), 
                color: Colors.white,
                onPressed: () => _onClickStore(),
              ),
            )
          );
        } //! descomentar
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
            if (compound.subproduct!.type == 3) { // type 3 = device
              if (compound.subproduct!.productTYpe == 3) {// type 3 = fan
                bool off = compound.subproduct!.activate == 0;
                buttons.add(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: IconButton(
                      icon: Icon(off ? MdiIcons.fanOff: MdiIcons.fan), 
                      onPressed: () => _onClickFan(context, compound.subproduct!, off),
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
            if (compound.subproduct!.type == 3) { // type 3 = device
              if (compound.subproduct!.productTYpe == 3) {// type 3 = fan
                bool off = compound.subproduct!.activate == 0;
                buttons.add(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: IconButton(
                      icon: Icon(off ? MdiIcons.fanOff: MdiIcons.fan), 
                      onPressed: () => _onClickFan(context, compound.subproduct!, off),
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
                onPressed: () => Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context) => RoomBeforeCleaningView(
                      env: widget.env,
                      room: widget.room, 
                      reviewPermission: reviewPermission
                    )
                  )
                ),
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
                    widget.room.statename,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ), 
                  ),
                  if (widget.room.product.time != null && (widget.room.product.activate == 1 || widget.room.product.activate == 3))
                    ElapsedTimeWidget(
                      time: widget.room.product.time!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      controlMinutes: controlMinutes,
                    ),
                ],
              )
            ],
          ), 
        ),
      ),
    );
  }

  void controlMinutes(int minutes) {
    if (actionsVisible) {
      if (minutes >= widget.room.product.tolerance!) {
        setState(() {
          actionsVisible = false;
        });
      }
    }
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

  Future<void> _cleanRoom({required BuildContext context, required Room room, required void Function(String) onOk} ) async {
    showLoaderDialog(context);
    Data<String> result = await roomService.cleanRoom(room, user: widget.login.user);
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

  Future<void> _changeRoom({required BuildContext context, required Room room, required Room newRoom, required void Function(String) onOk} ) async {
    showLoaderDialog(context);
    Data<String> result = await roomService.changeRoom(room, newRoom);
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
        _cleanRoom(
          context:  context, 
          room: widget.room, 
          onOk: (optionalMessage) =>  Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (BuildContext context) => 
                RoomBeforeCleaningView(
                  env: widget.env, 
                  room: widget.room, 
                  reviewPermission: reviewPermission
                )
            )
          ),
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
      message: "Se habilitará la cerradura y se encenderán las luces.", 
      onConfirmation: () {
        _actionRoom(
          context:  context, 
          room: widget.room, 
          serviceAction: roomService.cleanRoom, 
          onOk: (optionalMessage) =>  Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (BuildContext context) => RoomBeforeCleaningView(
                env: widget.env,
                room: widget.room, 
                reviewPermission: reviewPermission,
              )
            )
          ),
        );
        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomBeforeCleaningView(room: widget.room, reviewPermission: reviewPermission)));
      }
    );
  }

  void _onClickEnableRoom() {
    showConfirmationDialog(
      context: context, 
      title: "¿Habilitar habitación?",
      message: "Se habilitará la cerradura y se encenderán las luces.", 
      onConfirmation: () {
        _actionRoom(
          context:  context, 
          room: widget.room, 
          serviceAction: roomService.enableRoom, 
          onOk: (optionalMessage) {
            showMessageDialog(context: context, title: "Bien", message: optionalMessage,);
            setState(() {
              actionsVisible = true;
            });
          },
        );
      }
    );
  }

  void _onClickCancelRoom() {
    showConfirmationDialog(
      context: context, 
      title: "¿Cancelar habitación?",
      message: "Se desactivará la cerradura y se apagarán las luces.", 
      onConfirmation: () {
        _actionRoom(
          context:  context, 
          room: widget.room, 
          serviceAction: roomService.cancelRoom, 
          onOk: (optionalMessage) =>  showMessageDialog(context: context, title: "Bien", message: optionalMessage,),
        );
      }
    );
  }

  void _onClickChargeRoom() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (BuildContext context) => 
          PayView(env: widget.env, room: widget.room, user: widget.login.user)   
      )
    );
    // showConfirmationDialog(
    //   context: context, 
    //   title: "¿Cambiar de habitación?",
    //   message: "Se habilitará la cerradura y se encenderán las luces.", 
      
    //   onConfirmation: () {
    //     _actionRoom(
    //       context:  context, 
    //       room: widget.room, 
    //       serviceAction: roomService.enableRoom, 
    //       onOk: (optionalMessage) =>  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomBeforeCleaningView(room: widget.room, reviewPermission: reviewPermission,))),
    //     );
    //     // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomBeforeCleaningView(room: widget.room, reviewPermission: reviewPermission)));
    //   }
    // );
  }

  void _onClickChangeRoom() {
    List<Room> freeRooms = widget.roomList.where((room) => room.product.activate == 0).toList();
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("¿Cambiar de habitación?"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: freeRooms.map(
                    (freeRoom) => ChoiceChip(
                      label: SizedBox(width: double.maxFinite,child: Text(freeRoom.name)), 
                      selected: _selectedRoom == freeRoom,
                      selectedColor: const Color.fromARGB(255, 52, 195, 143),
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedRoom = selected ? freeRoom : null;
                        });
                      },
                    )).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _selectedRoom = null;
                    Navigator.of(context).pop();
                  }, 
                  child: const Text("Cancelar")
                ),
                TextButton(
                  onPressed: _selectedRoom != null ? 
                    () {
                      Navigator.of(context).pop();
                      _changeRoom(
                        context:  context, 
                        room: widget.room, 
                        newRoom: _selectedRoom!,
                        onOk: (optionalMessage) {
                          _selectedRoom = null;
                          showMessageDialog(context: context, title: "Bien", message: optionalMessage,);
                        },
                      );
                    } 
                  : null, 
                  child: const Text("Realizar cambio")
                )
              ],
            );
          }
        );
      },
    );
  }

  void _onClickStore() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (BuildContext context) => StoreView(env: widget.env, room: widget.room, user: widget.login.user,)
      )
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