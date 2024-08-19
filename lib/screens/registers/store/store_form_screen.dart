import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/store_model.dart';
import 'package:hotel/screens/registers/store/store_register_screen.dart';
import 'package:hotel/screens/registers/widgets/forms/footer_form_widget.dart';
import 'package:hotel/screens/registers/widgets/forms/header_form_widget.dart';

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
  Widget build(BuildContext context) {
    final String title = _createTitle();
    if (widget.store != null) {
      name.text = widget.store!.name;
    }
    return Form(
      key: _storeFormState,
      child: Column(
        children: [
          HeaderFormWidget(
            back: () { backFunction(); }, 
            title: title,
          ),
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
          FooterFormWidget(
            submit: () {}, 
            cancel: () {backFunction();},
            readOnly: widget.readOnly,
          )
        ],
      ),
    );
  }

  void backFunction() {
    widget.changeScreenTo(StoreRegisterScreen(changeScreenTo: widget.changeScreenTo));
  }

  String _createTitle() {
    String title = "Nuevo ";
      if(widget.store != null) {
        if (widget.readOnly) {
          title = "Ver ";
        } else {
          title = "Editar ";
        }
      }
      title += "almacen";
      return title;
  }
}
