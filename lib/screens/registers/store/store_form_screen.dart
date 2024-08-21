import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/store_model.dart';
import 'package:hotel/data/service/store_service.dart';
import 'package:hotel/screens/registers/store/store_register_screen.dart';
import 'package:hotel/screens/registers/widgets/forms/footer_form_widget.dart';
import 'package:hotel/screens/registers/widgets/forms/header_form_widget.dart';

import 'package:hotel/screens/widgets/dialog_functions.dart' as dialog_function;

class StoreFormScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;
  final Store? store;
  final bool readOnly;

  const StoreFormScreen({
    super.key, 
    required this.changeScreenTo, 
    this.store, 
    this.readOnly = false,
  });

  @override
  State<StoreFormScreen> createState() => _StoreFormScreenState();
}

class _StoreFormScreenState extends State<StoreFormScreen> {
  final GlobalKey<FormState> _storeFormState = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late String title;
    final Map<String, void Function()> actionsList = {};
    if (widget.store != null) {
      name.text = widget.store!.name;
    }
    switch(_formType()) {
      case 0:
        title = "Nuevo alamacén";
        actionsList["Crear Nuevo"] = () {
          if (_storeFormState.currentState!.validate()){
            createFunction(context);
          }
        };
        actionsList["Cancelar"] = () => backFunction();
      case 1:
        title = "Ver alamacén";
        actionsList["Volver"] = () => backFunction();
      case 2:
        title = "Modificar alamacén";
        actionsList["Guardar cambios"] = () {
          if (_storeFormState.currentState!.validate()){
            updateFunction(context);
          }
        };
        actionsList["Cancelar"] = () => backFunction();
    }
    return Form(
      key: _storeFormState,
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
    widget.changeScreenTo(StoreRegisterScreen(changeScreenTo: widget.changeScreenTo));
  }

  Future<void> createFunction(BuildContext context) async {
    dialog_function.showLoaderDialog(context);
    final storeService = StoreService();
    Data<String> result = await storeService.createStore(
      name.text,
    );
    if (context.mounted) dialog_function.closeLoaderDialog(context);

    if (result.data == null) {
      if (context.mounted) dialog_function.showInfoDialog(context, "Error", result.message);
    } else {
      widget.changeScreenTo(
        StoreRegisterScreen(
          changeScreenTo: widget.changeScreenTo,
          withSuccessMessage: result.data,
        )
      );
    }
  }

  Future<void> updateFunction(BuildContext context) async {
    Store store = Store(
      id: widget.store!.id, 
      name: name.text, 
      state: widget.store!.state
    );
    dialog_function.showLoaderDialog(context);
    final storeService = StoreService();
    Data<String> result = await storeService.updateStore(store);
    if (context.mounted) dialog_function.closeLoaderDialog(context);

    if (result.data == null) {
      if (context.mounted) dialog_function.showInfoDialog(context, "Error", result.message);
    } else {
      if (context.mounted) dialog_function.showInfoDialog(context, "Operación exitosa", result.data!);
    }
  }

  int _formType() {
    int type = 0;
    if(widget.store != null) {
      if (widget.readOnly) {
        type = 1;
      } else {
        type = 2;
      }
    }
    return type;
  }
}
