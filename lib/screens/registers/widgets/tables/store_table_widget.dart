import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/store_model.dart';
import 'package:hotel/screens/registers/store/store_form_screen.dart';
import 'package:hotel/screens/registers/widgets/tables/table_cells/actions_table_cell.dart';
import 'package:hotel/screens/registers/widgets/tables/table_cells/header_table_cell.dart';
import 'package:hotel/screens/registers/widgets/tables/table_cells/normal_table_cell.dart';
import 'package:hotel/screens/registers/widgets/tables/table_cells/state_table_cell.dart';

class StoreTableWidget extends StatelessWidget {
  final List<Store> storeList;
  final Function(Widget) changeScreenTo;
  
  const StoreTableWidget({
    super.key,
    required this.storeList, 
    required this.changeScreenTo
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(220),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[120]),
          children: const [
            HeaderTableCell(text: "Nombre"),
            HeaderTableCell(text: "Estado"),
            HeaderTableCell(text: "Acciones"),
          ],
        ),
        for (Store store in storeList)
          TableRow(
            decoration: BoxDecoration( color: Colors.grey[20], ),
            children: [
              NormalTableCell(child: Text(store.name)),
              StateTableCell(
                status: store.state, 
                activeLabel: "Activo", 
                activeColor: Colors.green.lightest, 
                inactiveColor: Colors.grey[110],
              ),
              ActionsTableCell(
                onSeePressed: () {
                  changeScreenTo(
                    StoreFormScreen(
                      store: store,
                      readOnly: true,
                      changeScreenTo: changeScreenTo
                    )
                  );
                },
                onEditPressed: () {
                  changeScreenTo(
                    StoreFormScreen(
                      store: store,
                      changeScreenTo: changeScreenTo
                    )
                  );
                },
                onDeletePressed: () {},
              )
            ]
          )
      ],
    );
  }
}