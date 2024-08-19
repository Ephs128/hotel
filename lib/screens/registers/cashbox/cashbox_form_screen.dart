import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/screens/registers/cashbox/cashbox_register_screen.dart';
import 'package:hotel/screens/registers/widgets/forms/footer_form_widget.dart';
import 'package:hotel/screens/registers/widgets/forms/header_form_widget.dart';

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
  Widget build(BuildContext context) {
    final String title = _createTitle();
    if (widget.cashbox != null) {
      name.text = widget.cashbox!.name;
      amount.text = widget.cashbox!.amount;
      virtualAmount.text = widget.cashbox!.virtualAmount;
      numberAccount.text = widget.cashbox!.numberAccount ?? "";
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
              label: "Numeroi de cuenta",
              child: TextFormBox(
                readOnly: widget.readOnly,
                controller: numberAccount,
                expands: false,
              ),
            ),
          ),
          const SizedBox(height: 30,),
          FooterFormWidget(
            submit: () {}, 
            cancel: () => backFunction(),
            readOnly: widget.readOnly,
          ),
        ],
      ),
    );
  }

  void backFunction() {
    widget.changeScreenTo(CashboxRegisterScreen(changeScreenTo: widget.changeScreenTo));
  }

  String _createTitle() {
    String title = "Nueva ";
      if(widget.cashbox != null) {
        if (widget.readOnly) {
          title = "Ver ";
        } else {
          title = "Editar ";
        }
      }
      title += "cuenta";
      return title;
  }
}