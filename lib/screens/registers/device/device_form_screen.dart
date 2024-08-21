import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/device_model.dart';
import 'package:hotel/data/service/device_service.dart';
import 'package:hotel/screens/registers/device/device_register_screen.dart';
import 'package:hotel/screens/registers/widgets/forms/header_form_widget.dart';

import 'package:hotel/screens/widgets/dialog_functions.dart' as dialog_function;

class DeviceFormScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;
  final Device? device;
  final bool readOnly;

  const DeviceFormScreen({
    super.key, 
    required this.changeScreenTo, 
    this.device, 
    this.readOnly = false,
  });

  @override
  State<DeviceFormScreen> createState() => _DeviceFormScreenState();
}

class _DeviceFormScreenState extends State<DeviceFormScreen> {
  final GlobalKey<FormState> _deviceFormState = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController position = TextEditingController();
  final TextEditingController code = TextEditingController();
  final TextEditingController serie = TextEditingController();
  final TextEditingController type = TextEditingController();

  final deviceService = DeviceService();

  @override
  void dispose() {
    name.dispose();
    position.dispose();
    code.dispose();
    serie.dispose();
    type.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late String title;
    final Map<String, void Function()> actionsList = {};
    if (widget.device != null) {
      name.text = widget.device!.name;
      position.text = widget.device!.position;
      code.text = widget.device!.productCode;
      serie.text = widget.device!.serie;
      type.text = widget.device!.type.toString();
    }
    switch(_formType()) {
      case 0:
        title = "Nuevo dispositivo";
        actionsList["Crear Nuevo"] = () {
          if (_deviceFormState.currentState!.validate()){
            createFunction(context);
          }
        };
        actionsList["Cancelar"] = () => backFunction();
      case 1:
        title = "Ver dispositivo";
        actionsList["Volver"] = () => backFunction();
      case 2:
        title = "Modificar dispositivo";
        actionsList["Guardar cambios"] = () {
          if (_deviceFormState.currentState!.validate()){
            updateFunction(context);
          }
        };
        actionsList["Cancelar"] = () => backFunction();
    }
    return Form(
      key: _deviceFormState,
      child: Column(
        children: [
          HeaderFormWidget(
            back: () { backFunction(); }, 
            title: title,
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
              child: TextFormBox(
                readOnly: widget.readOnly,
                controller: type,
                expands: false,
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
      ),
    );
  }

  void backFunction() {
    widget.changeScreenTo(DeviceRegisterScreen(changeScreenTo: widget.changeScreenTo));
  }

  Future<void> createFunction(BuildContext context) async {
    dialog_function.showLoaderDialog(context);
    
    Data<String> result = await deviceService.createDevice(
      name.text,
      position.text,
      code.text,
      serie.text,
      int.parse(type.text),
      false
    );
    if (context.mounted) dialog_function.closeLoaderDialog(context);

    if (result.data == null) {
      if (context.mounted) dialog_function.showInfoDialog(context, "Error", result.message);
    } else {
      widget.changeScreenTo(
        DeviceRegisterScreen(
          changeScreenTo: widget.changeScreenTo,
          withSuccessMessage: result.data,
        )
      );
    }
  }

  Future<void> updateFunction(BuildContext context) async {
    Device device = Device(
      id: widget.device!.id, 
      name: name.text,
      position: position.text,
      productCode: code.text,
      serie: serie.text,
      type: int.parse(type.text),
      activate: widget.device!.activate, 
      state: widget.device!.state,
      purchasePrice: widget.device!.purchasePrice,
      salePrice: widget.device!.salePrice,
      decription: widget.device!.decription,
      measure: widget.device!.measure
    );
    dialog_function.showLoaderDialog(context);
    Data<String> result = await deviceService.updateDevice(device);
    if (context.mounted) dialog_function.closeLoaderDialog(context);

    if (result.data == null) {
      if (context.mounted) dialog_function.showInfoDialog(context, "Error", result.message);
    } else {
      if (context.mounted) dialog_function.showInfoDialog(context, "Operación exitosa", result.data!);
    }
  }

  int _formType() {
    int type = 0;
    if(widget.device != null) {
      if (widget.readOnly) {
        type = 1;
      } else {
        type = 2;
      }
    }
    return type;
  }

}