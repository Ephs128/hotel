import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/service/cashbox_service.dart';
import 'package:hotel/screens/desktop/error_screen.dart';
import 'package:hotel/screens/desktop/registers/cashbox/cashbox_form_screen.dart';
import 'package:hotel/screens/desktop/widgets/tables/cashboxes_table_widget.dart';
import 'package:hotel/screens/desktop/widgets/loading_widget.dart';

import 'package:hotel/screens/desktop/widgets/dialog_functions.dart' as dialog_function;

class CashboxRegisterScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;
  final String? withSuccessMessage;
  final String? withErrorMessage;

  const CashboxRegisterScreen({
    super.key,
    required this.changeScreenTo, 
    this.withSuccessMessage, 
    this.withErrorMessage,
  });

  @override
  State<CashboxRegisterScreen> createState() => _CashboxRegisterScreenState();
}

class _CashboxRegisterScreenState extends State<CashboxRegisterScreen> {
  List<Cashbox> cashboxes = [];
  bool isLoaded = false;
  Data<List<Cashbox>>? result;
  bool firstCall = true;
  
  @override
  void initState() {
    super.initState();
    _fetchCashboxes();
    if (widget.withSuccessMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        dialog_function.showInfoDialog(context, "Operacion exitosa", widget.withSuccessMessage!);
      });
    } else {
      if (widget.withErrorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          dialog_function.showInfoDialog(context, "Error", widget.withErrorMessage!);
        });
      }
    }
  }

  Future<void> _fetchCashboxes() async {
    final cashboxService = CashboxService();
    result = await cashboxService.getAllCashboxes();
    cashboxes = result!.data ?? [];
    setState(() {
      isLoaded = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoaded) {
      return result!.data == null ?
        ErrorScreen(message: result!.message)
      : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton(
            child: const Icon(FluentIcons.add_medium),
            onPressed: () {
              widget.changeScreenTo(
                CashboxFormScreen(
                  changeScreenTo: widget.changeScreenTo,
                )
              );
            }, 
          ),
          const SizedBox(height: 20,),
          CashboxesTableWidget(
            cashboxList: cashboxes,
            changeScreenTo: widget.changeScreenTo,
            reload: () {
              setState(() {
                isLoaded = false;
              });
              _fetchCashboxes();
            },
          ),
        ],
      );
    } else {
      return const LoadingWidget();
    }
  }
}