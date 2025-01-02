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
  final bool reviewPermission;

  const RoomBeforeCleaningView({
    super.key,
    required this.room,
    required this.reviewPermission,
  });

  @override
  State<RoomBeforeCleaningView> createState() => _RoomBeforeCleaningViewState();

}

class _RoomBeforeCleaningViewState extends State<RoomBeforeCleaningView> {
  bool fan = false;
  final GlobalKey<FormState> _reportForm = GlobalKey<FormState>();
  final TextEditingController _observationsController = TextEditingController();
  final int cleanningProductsId = 4; //! Cambiar esto para filtrar
  final Map<int, String> _options = {
    1: "Limpieza rapida",
    2: "Limpieza normal",
    3: "Limpieza exhaustiva",
  };
  int selected = 1;
  List<ProductCleanning> selectedProducts = [];
  final RoomService _roomService = RoomService();
  
  @override
  Widget build(BuildContext context) {
    List<Widget> devices = [];
    for (Compound compound in widget.room.product.compounds) {
      if (compound.subproduct!.type == 3) {
        if (compound.subproduct!.productTYpe == 3) {
          bool off = compound.subproduct!.activate == 0;
          devices.add(
            Row(
              children: [
                Icon(MdiIcons.fan),
                const SizedBox(width: 10,),
                Text(compound.subproduct!.productName),
                const Spacer(),
                Switch(
                  value: !off, 
                  onChanged: (value) => _onClickFan(context, compound.subproduct!, off),
                )
              ]
            )
          );
          devices.add(const SizedBox(height: 20,));
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
      ),
      body: SingleChildScrollView(
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 20, color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _reportForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // Dispositivos

                  for (Widget device in devices) device,
 

                  const Text("Tipo de limpieza", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                  const SizedBox(height: 30,), 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all()
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      value: selected,
                      items: _options.keys.map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(_options[value].toString(), style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 22),)
                      )).toList() , 
                      onChanged: (value) {
                        setState(() {
                          selected = value ?? 1;
                        });
                      }
                    ),
                  ),
                  const SizedBox(height: 30,), 
                  
                  
                  const Text("Productos usados", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                  const SizedBox(height: 10,),
                  Table(
                    // border: TableBorder.all(),
                    columnWidths: const {
                      0: FlexColumnWidth(),
                      1: IntrinsicColumnWidth(),
                      // 2: IntrinsicColumnWidth(),
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
                            // TableCell(child: IconButton(icon: Icon(MdiIcons.trashCan), onPressed: () {},))
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
                  TextFormField(
                    controller: _observationsController,
                    validator: (value) {
                      if (value?.isNotEmpty == true) {
                        String filtered = value!.replaceAll("\n", "");
                        filtered = filtered.trim();
                        if (filtered.isNotEmpty) {
                          return null;
                        }
                      }
                      return 'Al realizar esta acción debe llenar este campo.';
                    },
                    decoration: const InputDecoration(
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
                  const SizedBox(height: 30,),

                  // -------------
                  // Botones
                  // -------------
                  
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30)
                      ),
                      onPressed: () => _startCleaning(context), 
                      child: const Text(
                        "Empezar limpieza", 
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  if (widget.reviewPermission)
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30)
                        ),
                        onPressed: () => _changeToDirty(context), 
                        child: const Text(
                          "Mandar a sucio", 
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 30,),
                  if (widget.reviewPermission)
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30)
                        ),
                        onPressed: () => _generateReport(context), 
                        child: const Text(
                          "Generar reporte", 
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
      ),
    );
  }

  Future<void> _navigateAndRetrieveSelectedProducts(BuildContext context) async {
    List<ProductCleanning>? result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RoomCleaningProductView(room: widget.room, cleanningProductsId: cleanningProductsId, selectedProducts: selectedProducts,)));
    if (!context.mounted) return;
    if(result != null){
      setState(() {
        selectedProducts = result;
      });
    }
  }

  void _startCleaning(BuildContext context) {
    RoomState roomState = RoomState(
      idRoom: widget.room.id, 
      detail: _observationsController.text,
      type: selected, 
      productsCleanning: selectedProducts
    );
    showConfirmationDialog(
      context: context, 
      title: "¿Desea empezar la limpieza?",
      message: "Empezará el contador y no podrá agregar mas productos o realizar cambios", 
      onConfirmation: () async {
        showLoaderDialog(context);
        Data<String> result = await _roomService.cleanStart(roomState);
        if (context.mounted) closeLoaderDialog(context);
        
        if (result.data != null) {
          if (context.mounted) Navigator.of(context).pop();
        } else {
          if (context.mounted){
            showMessageDialog(
              context: context, 
              title: "Error",
              message: result.message,
            );
          }
        }
      }
    );
  }

  void _changeToDirty(context) {
    if (_reportForm.currentState!.validate()) {
      RoomState roomState = RoomState(
        activate: 5, //! check this
        idRoom: widget.room.id, 
        detail: _observationsController.text,
        type: 4, 
        productsCleanning: []
      );
      showConfirmationDialog(
        context: context, 
        title: "¿Desea establecer la habitación como sucia?",
        message: "La habitación se indicará que está sucia para que alguien realice la respectiva limpieza. Esta acción cerrará la puerta y apagará las luces. Asegurese de estar fuera de la habitación antes de continuar.", 
        onConfirmation: () async {
          showLoaderDialog(context);
          Data<String> result = await _roomService.generateReport(roomState);
          if (context.mounted) closeLoaderDialog(context);

          if (result.data != null) {
            result = await _roomService.cleanRoom(widget.room, activate: 2);
            if (context.mounted) Navigator.of(context).pop();
          } else {
            if (context.mounted){
              showMessageDialog(
                context: context, 
                title: "Error",
                message: result.message,
              );
            }
          }
        }
      );
    }
  }

  void _generateReport(context) {
    if (_reportForm.currentState!.validate()) {
      RoomState roomState = RoomState(
        activate: 5,
        idRoom: widget.room.id, 
        detail: _observationsController.text,
        type: 4, 
        productsCleanning: []
      );
      showConfirmationDialog(
        context: context, 
        title: "¿Desea generar el reporte?",
        message: "Esta acción cerrará la puerta y apagará las luces. Asegurese de estar fuera de la habitación antes de continuar.", 
        onConfirmation: () async {
          showLoaderDialog(context);
          Data<String> result = await _roomService.generateReport(roomState);
          if (context.mounted) closeLoaderDialog(context);
          
          if (result.data != null) {
            result = await _roomService.cleanRoom(widget.room, activate: 0);
            if (context.mounted) Navigator.of(context).pop();
          } else {
            if (context.mounted){
              showMessageDialog(
                context: context, 
                title: "Error",
                message: result.message,
              );
            }
          }
        }
      );
    }
  }

  void _onClickFan(BuildContext context, Product device, bool isOff) async {
    showLoaderDialog(context);
    Data<String> result = await _roomService.dispRoom(device, isOff ? 1 : 0);
    if (context.mounted) {
      closeLoaderDialog(context);
      if(result.data == null) {
        showMessageDialog(
          context: context, 
          title: "Hubo un error",
          message: result.message,
        );
      } else {
        setState(() {
          isOff = true;
        });
      }
    }
  }
}