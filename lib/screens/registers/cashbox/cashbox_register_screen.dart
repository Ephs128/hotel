import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/service/cashbox_service.dart';
import 'package:hotel/screens/error_screen.dart';
import 'package:hotel/screens/registers/cashbox/cashbox_form_screen.dart';
import 'package:hotel/screens/registers/widgets/tables/cashboxes_table_widget.dart';
import 'package:hotel/screens/widgets/loading_widget.dart';

class CashboxRegisterScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;

  const CashboxRegisterScreen({
    super.key,
    required this.changeScreenTo,
  });

  @override
  State<CashboxRegisterScreen> createState() => _CashboxRegisterScreenState();
}

class _CashboxRegisterScreenState extends State<CashboxRegisterScreen> {
  List<Cashbox> cashboxes = [];
  bool isLoaded = false;
  Data<List<Cashbox>>? result;
  
  @override
  void initState() {
    super.initState();
    _fetchCashboxes();
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
          ),
        ],
      );
    } else {
      return const LoadingWidget();
    }
  }
}