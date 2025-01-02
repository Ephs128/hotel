import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/service/room_service.dart';
import 'package:hotel/screens/desktop/registers/room/room_form_screen.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/actions_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/header_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/normal_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/state_table_cell.dart';

import 'package:hotel/screens/desktop/widgets/dialog_functions.dart' as dialog_function;

class RoomTableWidget extends StatelessWidget {
  final List<Room> roomList;
  final Function(Widget) changeScreenTo;
  final Function() reload;

  const RoomTableWidget({
    super.key, 
    required this.roomList, 
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
        for (Room room in roomList)
          TableRow(
            decoration: BoxDecoration( color: Colors.grey[20], ),
            children: [
              NormalTableCell(child: Text(room.name)),
              StateTableCell( 
                status: room.state ?? false, 
                activeLabel: "Activo", 
                activeColor: Colors.green.lightest, 
                inactiveColor: Colors.grey[110],
              ),
              ActionsTableCell(
                onSeePressed: () {
                  changeScreenTo(
                    RoomFormScreen(
                      changeScreenTo: changeScreenTo,
                      readOnly: true,
                      room: room,
                    )
                  );
                },
                onEditPressed: () {
                  changeScreenTo(
                    RoomFormScreen(
                      changeScreenTo: changeScreenTo,
                      room: room,
                    )
                  );
                },
                onDeletePressed: () {
                  dialog_function.showConfirmationDialog(
                    context, 
                    "Confirmación", 
                    "Está por eliminar el dispositivo ${room.name}", 
                    () {deleteDevice(context, room);}
                  );
                },
              ),
            ],
          )
      ],
    );
  }

  Future<void> deleteDevice(BuildContext context, Room room) async {
    dialog_function.showLoaderDialog(context);
    final roomService = RoomService();
    // Todo: change for deltete room
    // Data<String> result = await storeService.deleteDevice(device);
    if(context.mounted) dialog_function.closeLoaderDialog(context);
    // if (result.data == null) {
    //   if (context.mounted) dialog_function.showInfoDialog(context, "Error", result.message);
    // } else {
    //   reload();
    // }
  }

}