import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/service/cashbox_service.dart';
import 'package:hotel/screens/registers/cashbox/cashbox_form_screen.dart';
import 'package:hotel/widgets/tables/table_cells/actions_table_cell.dart';
import 'package:hotel/widgets/tables/table_cells/header_table_cell.dart';
import 'package:hotel/widgets/tables/table_cells/normal_table_cell.dart';
import 'package:hotel/widgets/tables/table_cells/state_table_cell.dart';

import 'package:hotel/widgets/dialog_functions.dart' as dialog_function;

class CashboxesTableWidget extends StatelessWidget {
  final List<Cashbox> cashboxList;
  final Function(Widget) changeScreenTo;
  final Function() reload;
  
  const CashboxesTableWidget({
    super.key, 
    required this.cashboxList,
    required this.changeScreenTo, 
    required this.reload, 
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
        5: FixedColumnWidth(220),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[120]),
          children: const [
            HeaderTableCell(text: "Nombre"),
            HeaderTableCell(text: "Cantidad"),
            HeaderTableCell(text: "Cantidad virtual"),
            HeaderTableCell(text: "Número de cuenta"),
            HeaderTableCell(text: "Estado"),
            HeaderTableCell(text: "Acciones"),
          ],
        ),
        for (Cashbox cashbox in cashboxList)
          TableRow(
            decoration: BoxDecoration( color: Colors.grey[20], ),
            children: [
              NormalTableCell(child: Text(cashbox.name)),
              NormalTableCell(child: Text(cashbox.amount)),
              NormalTableCell(child: Text(cashbox.virtualAmount)),
              NormalTableCell(child: Text(cashbox.numberAccount ?? "-")),
              StateTableCell(
                status: cashbox.state, 
                activeLabel: "Activo", 
                activeColor: Colors.green.lightest, 
                inactiveColor: Colors.grey[110],
              ),
              ActionsTableCell(
                onSeePressed: () {
                  changeScreenTo(
                    CashboxFormScreen(
                      cashbox: cashbox,
                      readOnly: true,
                      changeScreenTo: changeScreenTo
                    )
                  );
                },
                onEditPressed: () {
                  changeScreenTo(
                    CashboxFormScreen(
                      cashbox: cashbox,
                      changeScreenTo: changeScreenTo
                    )
                  );
                },
                onDeletePressed: () {
                  dialog_function.showConfirmationDialog(
                    context, 
                    "Confirmación", 
                    "Está por eliminar la cuenta ${cashbox.name}", 
                    () {deleteCashbox(context, cashbox);}
                  );
                },
              )
            ]
          )
      ],
    );
  }

  Future<void> deleteCashbox(BuildContext context, Cashbox cashbox) async {
    dialog_function.showLoaderDialog(context);
    final cashboxService = CashboxService();
    Data<String> result = await cashboxService.deleteCashbox(cashbox);
    if(context.mounted) dialog_function.closeLoaderDialog(context);
    if (result.data == null) {
      if (context.mounted) dialog_function.showInfoDialog(context, "Error", result.message);
    } else {
      reload();
    }
  }
}