import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/screens/desktop/registers/user/user_form_screen.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/actions_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/header_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/normal_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/state_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_constants.dart' as constants;

class UsersTable extends StatelessWidget {
  final List<User> usersList;
  final Function(Widget) changeScreenTo;
  final Function() reload;

  const UsersTable({
    super.key, 
    required this.usersList, 
    required this.changeScreenTo,
    required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FixedColumnWidth(220),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: constants.headerTableBackground),
          children: [
            HeaderTableCell(text: "Nombre"),
            HeaderTableCell(text: "Usuario"),
            HeaderTableCell(text: "Rol"),
            HeaderTableCell(text: "Estado"),
            HeaderTableCell(text: "Acciones"),
          ]
        ),
        for (User user in usersList)
          TableRow(
            decoration: const BoxDecoration(color: constants.tableBackground),
            children: [
              NormalTableCell(child: Text(user.person!.getName())),
              NormalTableCell(child: Text(user.user)),
              NormalTableCell(child: Text(user.role!.role)),
              StateTableCell(
                status: user.state, 
                activeLabel: "Activo", 
                activeColor: Colors.green.lightest, 
                inactiveColor: Colors.grey[110],
              ),
              ActionsTableCell(
                onSeePressed: () {
                  changeScreenTo(
                    UserFormScreen(
                      changeScreenTo: changeScreenTo, 
                      readOnly: true,
                      user: user,
                    )
                  );
                },
                onEditPressed: () {
                  changeScreenTo(
                    UserFormScreen(
                      changeScreenTo: changeScreenTo, 
                      user: user,
                    )
                  );
                },
                onDeletePressed: () {},
              ),
            ]
          ),
        
      ],
    );
  }
}
