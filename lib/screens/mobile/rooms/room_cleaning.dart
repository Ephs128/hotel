import 'package:flutter/material.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/screens/mobile/rooms/room_cleaning_product_view.dart';

import 'package:hotel/screens/mobile/widgets/dialogs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RoomCleaning extends StatefulWidget {
  
  final Room room;
  
  const RoomCleaning({
    super.key,
    required this.room,
  });

  @override
  State<RoomCleaning> createState() => _RoomCleaningState();

}

class _RoomCleaningState extends State<RoomCleaning> {
  bool fan = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Habitación ${widget.room.name}"),
      ),
      body: SingleChildScrollView(
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 24, color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(MdiIcons.fan),
                    const SizedBox(width: 10,),
                    const Text("Ventilador",),
                    const Spacer(),
                    Switch(
                      value: fan, 
                      onChanged: (value) {
                        // todo: await api call
                        setState(() {
                          fan = value;
                        });
                      }
                    )
                  ],
                ),
                const SizedBox(height: 30,), 
                const Text("Productos usados"),
                const SizedBox(height: 10,),
                Table(
                  // border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: IntrinsicColumnWidth(),
                    2: IntrinsicColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        const TableCell(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Jabon"),
                        )),
                        const TableCell(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("2"),
                        )),
                        TableCell(child: IconButton(icon: Icon(MdiIcons.trashCan), onPressed: () {},))
                      ]
                    ),
                    TableRow(
                      children: [
                        const TableCell(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Shampoo"),
                        )),
                        const TableCell(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("2"),
                        )),
                        TableCell(child: IconButton(icon: Icon(MdiIcons.trashCan), onPressed: () {},))
                      ]
                    )
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 30)
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomCleaningProductView(room: widget.room))), 
                    child: const Text(
                      "Agregar producto", 
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                const Text("Observaciones: "),
                const SizedBox(height: 10,),
                const TextField(
                  decoration: InputDecoration(
                    hintText: "Puede escribir las observaciones encontradas en este espacio.",
                    hintMaxLines: 3,
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                  ),
                  minLines: 6,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
                // const Spacer(),
                const SizedBox(height: 30,),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30)
                    ),
                    onPressed: () => endCleaning(context), 
                    child: const Text(
                      "Terminar limpieza", 
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // resizeToAvoidBottomInset: true,

    );
  }

  void endCleaning(BuildContext context) {
    showConfirmationDialog(
      context: context, 
      title: "¿Desea terminar la limpieza?",
      message: "Se cerrará la puerta y se apagarán las luces.", 
      onConfirmation: () {
        // todo: call api
        Navigator.of(context).pop();
      }
    );
  }

}