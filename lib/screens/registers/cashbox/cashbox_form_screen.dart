import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/service/cashbox_service.dart';
import 'package:hotel/screens/registers/cashbox/cashbox_register_screen.dart';
import 'package:hotel/widgets/forms/header_form_widget.dart';

import 'package:hotel/widgets/dialog_functions.dart' as dialog_function;

class CashboxFormScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;
  final Cashbox? cashbox;
  final bool readOnly;

  const CashboxFormScreen({
    super.key, 
    required this.changeScreenTo, 
    this.cashbox, 
    this.readOnly = false,
  });

  @override
  State<CashboxFormScreen> createState() => _CashboxFormScreenState();
}

class _CashboxFormScreenState extends State<CashboxFormScreen> {
  final GlobalKey<FormState> _cashboxFormState = GlobalKey<FormState>();
  
  final TextEditingController name = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController virtualAmount = TextEditingController();
  final TextEditingController numberAccount = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    amount.dispose();
    virtualAmount.dispose();
    numberAccount.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late String title;
    final Map<String, void Function()> actionsList = {};
    if (widget.cashbox != null) {
      name.text = widget.cashbox!.name;
      amount.text = widget.cashbox!.amount;
      virtualAmount.text = widget.cashbox!.virtualAmount;
      numberAccount.text = widget.cashbox!.numberAccount ?? "";
    }
    switch(_formType()) {
      case 0:
        title = "Nueva cuenta";
        actionsList["Crear Nuevo"] = () {
          if (_cashboxFormState.currentState!.validate()){
            createFunction(context);
          }
        };
        actionsList["Cancelar"] = () => backFunction();
      case 1:
        title = "Ver cuenta";
        actionsList["Volver"] = () => backFunction();
      case 2:
        title = "Modificar cuenta";
        actionsList["Guardar cambios"] = () {
          if (_cashboxFormState.currentState!.validate()){
            updateFunction(context);
          }
        };
        actionsList["Cancelar"] = () => backFunction();
    }
    return Form(
      key: _cashboxFormState,
      child: Column(
        children: [
          HeaderFormWidget(
            back: () => backFunction(), 
            title: title,
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            child: InfoLabel(
              label: "Nombre de cuenta",
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
              label: "Cantidad",
              child: TextFormBox(
                readOnly: widget.readOnly,
                controller: amount,
                expands: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            child: InfoLabel(
              label: "Cantidad virtual",
              child: TextFormBox(
                readOnly: widget.readOnly,
                controller: virtualAmount,
                expands: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
            child: InfoLabel(
              label: "Numero de cuenta",
              child: TextFormBox(
                readOnly: widget.readOnly,
                controller: numberAccount,
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
    widget.changeScreenTo(CashboxRegisterScreen(changeScreenTo: widget.changeScreenTo));
  }

  Future<void> createFunction(BuildContext context) async {
    dialog_function.showLoaderDialog(context);
    final cashboxService = CashboxService();
    Data<String> result = await cashboxService.createCashbox(
      name.text, 
      amount.text.isEmpty? null : amount.text, 
      virtualAmount.text.isEmpty? null : virtualAmount.text, 
      numberAccount.text.isEmpty? null : numberAccount.text
    );
    if (context.mounted) dialog_function.closeLoaderDialog(context);

    if (result.data == null) {
      if (context.mounted) dialog_function.showInfoDialog(context, "Error", result.message);
    } else {
      widget.changeScreenTo(
        CashboxRegisterScreen(
          changeScreenTo: widget.changeScreenTo,
          withSuccessMessage: result.data,
        )
      );
    }
  }

  Future<void> updateFunction(BuildContext context) async {
    Cashbox cashbox = Cashbox(
      id: widget.cashbox!.id, 
      name: name.text, 
      amount: amount.text, 
      virtualAmount: virtualAmount.text, 
      state: widget.cashbox!.state
    );
    dialog_function.showLoaderDialog(context);
    final cashboxService = CashboxService();
    Data<String> result = await cashboxService.updateCashbox(cashbox);
    if (context.mounted) dialog_function.closeLoaderDialog(context);

    if (result.data == null) {
      if (context.mounted) dialog_function.showInfoDialog(context, "Error", result.message);
    } else {
      if (context.mounted) dialog_function.showInfoDialog(context, "Operación exitosa", result.data!);
    }
  }

  int _formType() {
    int type = 0;
    if(widget.cashbox != null) {
      if (widget.readOnly) {
        type = 1;
      } else {
        type = 2;
      }
    }
    return type;
  }
}