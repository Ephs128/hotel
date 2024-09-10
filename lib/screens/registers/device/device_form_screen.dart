import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/device_model.dart';
import 'package:hotel/data/service/device_service.dart';
import 'package:hotel/screens/registers/device/device_register_screen.dart';
import 'package:hotel/widgets/forms/header_form_widget.dart';

import 'package:hotel/widgets/dialog_functions.dart' as dialog_function;

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

  final deviceService = DeviceService();

  int functionType = 0;
  int selectedType = 0;

  @override
  void dispose() {
    name.dispose();
    position.dispose();
    code.dispose();
    serie.dispose();

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
      selectedType = widget.device!.type;
      functionType = widget.device!.pulse ? 0 : 1;
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
              child: ComboBox<int>(
                isExpanded: true,
                value: selectedType,
                items: const [
                  ComboBoxItem<int>(
                    value: 0,
                    child: Text("Cerradura"),
                  ),
                  ComboBoxItem<int>(
                    value: 1,
                    child: Text("Luz"),
                  ),
                  ComboBoxItem<int>(
                    value: 2,
                    child: Text("Jacuzzi"),
                  ),
                  ComboBoxItem<int>(
                    value: 3,
                    child: Text("Ventilación"),
                  ),
                  ComboBoxItem<int>(
                    value: 4,
                    child: Text("Puerta"),
                  ),
                ],
                onChanged: widget.readOnly ? null : (value) {
                  setState(() {
                    selectedType = value ?? 0;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            child: InfoLabel(
              label: "Método de funcionamiento",
              child: ComboBox<int>(
                isExpanded: true,
                value: functionType,
                items: const [
                  ComboBoxItem<int>(
                    value: 0,
                    child: Text("Pulso"),
                  ),
                  ComboBoxItem<int>(
                    value: 1,
                    child: Text("Automatico"),
                  ),
                ],
                onChanged: widget.readOnly ? null : (value) {
                  setState(() {
                    functionType = value ?? 0;
                  });
                },
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
      selectedType,
      functionType == 1,
      functionType == 0
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
      type: widget.device!.type,
      activate: widget.device!.activate, 
      automatic: widget.device!.automatic, 
      pulse: widget.device!.pulse,
      state: widget.device!.state
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