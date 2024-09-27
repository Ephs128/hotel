import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/device_model.dart';
import 'package:hotel/data/service/device_service.dart';
import 'package:hotel/screens/desktop/registers/device/device_form_screen.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/actions_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/header_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/normal_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/state_table_cell.dart';

import 'package:hotel/screens/desktop/widgets/dialog_functions.dart' as dialog_function;

class DevicesTableWidget extends StatelessWidget {
  final List<Device> deviceList;
  final Function(Widget) changeScreenTo;
  final Function() reload;

  const DevicesTableWidget({
    super.key, 
    required this.deviceList, 
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
        5: FlexColumnWidth(),
        6: FixedColumnWidth(220),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[120]),
          children: const [
            HeaderTableCell(text: "Nombre"),
            HeaderTableCell(text: "Posición"),
            HeaderTableCell(text: "Código"),
            HeaderTableCell(text: "Serie"),
            HeaderTableCell(text: "Tipo"),
            HeaderTableCell(text: "Estado"),
            HeaderTableCell(text: "Acciones"),
          ],
        ),
        for (Device device in deviceList)
          TableRow(
            decoration: BoxDecoration( color: Colors.grey[20], ),
            children: [
              NormalTableCell(child: Text(device.name)),
              NormalTableCell(child: Text(device.position)),
              NormalTableCell(child: Text(device.productCode)),
              NormalTableCell(child: Text(device.serie)),
              NormalTableCell(child: Text(device.type.toString())),
              StateTableCell( 
                status: device.state, 
                activeLabel: "Activo", 
                activeColor: Colors.green.lightest, 
                inactiveColor: Colors.grey[110],
              ),
              ActionsTableCell(
                onSeePressed: () {
                  changeScreenTo(
                    DeviceFormScreen(
                      changeScreenTo: changeScreenTo,
                      readOnly: true,
                      device: device,
                    )
                  );
                },
                onEditPressed: () {
                  changeScreenTo(
                    DeviceFormScreen(
                      changeScreenTo: changeScreenTo,
                      device: device,
                    )
                  );
                },
                onDeletePressed: () {
                  dialog_function.showConfirmationDialog(
                    context, 
                    "Confirmación", 
                    "Está por eliminar el dispositivo ${device.name}", 
                    () {deleteDevice(context, device);}
                  );
                },
              ),
            ],
          )
      ],
    );
  }

  Future<void> deleteDevice(BuildContext context, Device device) async {
    dialog_function.showLoaderDialog(context);
    final storeService = DeviceService();
    Data<String> result = await storeService.deleteDevice(device);
    if(context.mounted) dialog_function.closeLoaderDialog(context);
    if (result.data == null) {
      if (context.mounted) dialog_function.showInfoDialog(context, "Error", result.message);
    } else {
      reload();
    }
  }

}