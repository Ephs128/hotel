import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hotel/data/models/compound_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/product_cleanning_model.dart';
import 'package:hotel/data/models/product_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/models/room_state_model.dart';
import 'package:hotel/data/service/room_service.dart';
import 'package:hotel/screens/mobile/rooms/room_cleaning_product_view.dart';

import 'package:hotel/screens/mobile/widgets/dialogs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RoomBeforeCleaningView extends StatefulWidget {
  
  final Room room;
  
  const RoomBeforeCleaningView({
    super.key,
    required this.room,
  });

  @override
  State<RoomBeforeCleaningView> createState() => _RoomBeforeCleaningViewState();

}

class _RoomBeforeCleaningViewState extends State<RoomBeforeCleaningView> {
  bool fan = false;
  final int cleanningProductsId = 4; //! Cambiar esto para filtrar
  final Map<int, String> options = {
    1: "Limpieza rapida",
    2: "Limpieza normal",
    3: "Limpieza exhaustiva",
  };
  int selected = 1;
  List<ProductCleanning> selectedProducts = [];
  final RoomService _roomService = RoomService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
      ),
      body: SingleChildScrollView(
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 20, color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Tipo de limpieza", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                DropdownButton(
                  value: selected,
                  items: options.keys.map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(options[value].toString())
                  )).toList() , 
                  onChanged: (value) {
                    setState(() {
                      selected = value ?? 1;
                    });
                  }
                ),
                for (Compound compound in widget.room.product.compounds) 
                  if (compound.subproduct.type == 3)
                    if (compound.subproduct.productTYpe == 3) 
                      Row(
                        children: [
                          Icon(MdiIcons.fan),
                          const SizedBox(width: 10,),
                          Text(compound.subproduct.productName),
                          const Spacer(),
                          Switch(
                            value: compound.subproduct.activate == 1, 
                            onChanged: (value) {
                              // todo: await api call
                              setState(() {
                                compound.subproduct.activate = value? 1 : 0;
                              });
                            }
                          )
                  ],
                ),
                const SizedBox(height: 30,), 
                const Text("Productos usados", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                const SizedBox(height: 10,),
                Table(
                  // border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: IntrinsicColumnWidth(),
                    2: IntrinsicColumnWidth(),
                  },
                  children: [
                    for(ProductCleanning product in selectedProducts)
                      TableRow(
                        children: [
                          TableCell(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(product.productName),
                          )),
                          TableCell(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(product.cantity.toString()),
                          )),
                          TableCell(child: IconButton(icon: Icon(MdiIcons.trashCan), onPressed: () {},))
                        ]
                      ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 30)
                    ),
                    onPressed: () => _navigateAndRetrieveSelectedProducts(context), 
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
                const Text("Observaciones: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
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
                      "Empezar limpieza", 
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

  Future<void> _navigateAndRetrieveSelectedProducts(BuildContext context) async {
    List<ProductCleanning> result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomCleaningProductView(room: widget.room, cleanningProductsId: cleanningProductsId, selectedProducts: selectedProducts,)));
    if (!context.mounted) return;
    setState(() {
      selectedProducts = result;
    });
  }

  void endCleaning(BuildContext context) {
    RoomState roomState = RoomState(
      idRoom: widget.room.id, 
      type: selected, 
      productsCleanning: selectedProducts
    );
    showConfirmationDialog(
      context: context, 
      title: "¿Desea empezar la limpieza?",
      message: "Empezará el contador y no podrá agregar mas productos", 
      onConfirmation: () async {
        showLoaderDialog(context);
        Data<String> result = await _roomService.cleanStart(roomState);
        if (result.data != null) {
          log(result.data!);
        } else {
          log(result.message);
        }
        
        if (context.mounted) Navigator.of(context).pop();
      }
    );
  }

}