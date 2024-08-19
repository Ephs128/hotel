import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/screens/registers/widgets/tables/table_cells/actions_table_cell.dart';
import 'package:hotel/screens/registers/widgets/tables/table_cells/header_table_cell.dart';
import 'package:hotel/screens/registers/widgets/tables/table_cells/normal_table_cell.dart';
import 'package:hotel/screens/registers/widgets/tables/table_cells/state_table_cell.dart';

class RolesTableWidget extends StatelessWidget {
  final List<Role> roleList;
  const RolesTableWidget({
    super.key, 
    required this.roleList,
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
        for (Role role in roleList)
          TableRow(
            decoration: BoxDecoration( color: Colors.grey[20], ),
            children: [
              NormalTableCell(child: Text(role.role)),
              StateTableCell(
                status: role.state, 
                activeLabel: "Activo", 
                activeColor: Colors.green.lightest, 
                inactiveColor: Colors.grey[110],
              ),
              ActionsTableCell(
                onSeePressed: () {},
                onEditPressed: () {},
                onDeletePressed: () {},
              )
            ]
          )
      ],
    );
  }
}