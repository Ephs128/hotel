import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/device_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/service/device_service.dart';
import 'package:hotel/data/service/room_service.dart';
import 'package:hotel/screens/desktop/error_screen.dart';
import 'package:hotel/screens/desktop/widgets/devices_checkbox_widget.dart';
import 'package:hotel/screens/desktop/widgets/forms/header_form_widget.dart';

import 'package:hotel/screens/desktop/widgets/dialog_functions.dart' as dialog_function;

class RoomFormScreen extends StatefulWidget {
  
  final Function(Widget) changeScreenTo;
  final Room? room;
  final bool readOnly;

  const RoomFormScreen({
    super.key,
    required this.changeScreenTo,
    this.room,
    this.readOnly = false,
  });

  @override
  State<RoomFormScreen> createState() => _RoomFormScreenState();
}

class _RoomFormScreenState extends State<RoomFormScreen> {

  final GlobalKey<FormState> _roomsFormState = GlobalKey<FormState>();
  
  final TextEditingController name = TextEditingController();
  final TextEditingController position = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController serie = TextEditingController();
  int selectedType = 0;
  final Map<int, String> types = {
    0: "Habitación tipo 0",
    1: "Habitación tipo 1",
    2: "Habitación tipo 2",
    3: "Habitación tipo 3",
  };

  final RoomService _roomService = RoomService();
  final DeviceService _deviceService = DeviceService();
  final Map<Device, bool> deviceMap = {};
  late String title;
  final Map<String, void Function()> actionsList = {};

  bool _isLoaded = false;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchData();
      if (widget.room != null) {
        // TODO init controllers
      }
      switch(_formType()) {
        case 0:
        title = "Nueva habitación";
        actionsList["Crear Nuevo"] = () {
          if (_roomsFormState.currentState!.validate()){
            createFunction(context);
          }
        };
        actionsList["Cancelar"] = () => backFunction();
      case 1:
        title = "Ver habitación";
        actionsList["Volver"] = () => backFunction();
      case 2:
        title = "Modificar habitación";
        actionsList["Guardar cambios"] = () {
          if (_roomsFormState.currentState!.validate()){
            updateFunction(context);
          }
        };
        actionsList["Cancelar"] = () => backFunction();
      }
  }

  Future<void> _fetchData() async {
    final result = await _deviceService.getAllDevices();
    if (result.data != null) {
      for(Device device in result.data!) {
        deviceMap[device] = false;
      }
    } else {
      errorMsg = result.message;
    }
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded) {
      return errorMsg != null ?
        ErrorScreen(message: errorMsg!)
      : Form(
          key: _roomsFormState,
          child: Column(
            children: [
              HeaderFormWidget(
                back: () => backFunction(), 
                title: title
              ),
              const SizedBox(height: 30,),
              Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            child: InfoLabel(
              label: "Nombre",
              child: TextFormBox(
                readOnly: widget.readOnly,
                controller: name,
                expands: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            child: InfoLabel(
              label: "Posición",
              child: TextFormBox(
                readOnly: widget.readOnly,
                controller: position,
                expands: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            child: InfoLabel(
              label: "Código",
              child: TextFormBox(
                readOnly: widget.readOnly,
                controller: code,
                expands: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            child: InfoLabel(
              label: "Serie",
              child: TextFormBox(
                readOnly: widget.readOnly,
                controller: serie,
                expands: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            child: InfoLabel(
              label: "Tipo",
              child: ComboBox<int>(
                value: selectedType,
                items: types.keys.map((e){
                  return ComboBoxItem<int>(
                    value: e,
                    child: Text(types[e]!)
                  );
                }).toList(),
                onChanged: widget.readOnly ? null : (value) => setState(() {
                  selectedType = value ?? 0;
                }),
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            child: InfoLabel(
              label: "Dispositivos",
              child: DevicesCheckboxWidget(
                devices: deviceMap,
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [ for(String name in actionsList.keys) 
              FilledButton(
                onPressed: actionsList[name],
                child: Text(name), 
              ),
            ],
          )
            ],
          )
        );
    } else {
      return const Placeholder();
    }
  }

  void backFunction() {
    // todo
  }

  Future<void> createFunction(BuildContext context) async {
    dialog_function.showLoaderDialog(context);
    
    // Data<String> result = await _roomService.createRoom();
    if (context.mounted) dialog_function.closeLoaderDialog(context);
  }

  Future<void> updateFunction(BuildContext context) async {
    // todo
  }

  int _formType() {
    int type = 0;
    if(widget.room != null) {
      if (widget.readOnly) {
        type = 1;
      } else {
        type = 2;
      }
    }
    return type;
  }
}