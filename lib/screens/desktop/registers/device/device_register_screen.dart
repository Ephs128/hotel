import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/device_model.dart';
import 'package:hotel/data/service/device_service.dart';
import 'package:hotel/screens/desktop/error_screen.dart';
import 'package:hotel/screens/desktop/registers/device/device_form_screen.dart';
import 'package:hotel/screens/desktop/widgets/tables/devices_table_widget.dart';

import 'package:hotel/screens/desktop/widgets/dialog_functions.dart' as dialog_function;
import 'package:hotel/screens/desktop/widgets/loading_widget.dart';

class DeviceRegisterScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;
  final String? withSuccessMessage;
  final String? withErrorMessage;

  const DeviceRegisterScreen({
    super.key, 
    required this.changeScreenTo,
    this.withSuccessMessage,
    this.withErrorMessage,
  });

  @override
  State<DeviceRegisterScreen> createState() => _DeviceRegisterScreenState();
}

class _DeviceRegisterScreenState extends State<DeviceRegisterScreen> {
  List<Device> devices = [];
  bool isLoaded = false;
  Data<List<Device>> ? result;

  @override
  void initState() {
    super.initState();
    _fetchDevices();
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

  Future<void> _fetchDevices() async {
    final storeService = DeviceService();
    result = await storeService.getAllDevices();
    devices = result!.data ?? [];
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
                DeviceFormScreen(
                  changeScreenTo: widget.changeScreenTo,
                )
              );
            }, 
          ),
          const SizedBox(height: 20,),
          DevicesTableWidget(
            deviceList: devices,
            changeScreenTo: widget.changeScreenTo,
            reload: () {
              setState(() {
                isLoaded = false;
              });
              _fetchDevices();
            },
          ),
        ],
      );
    } else {
      return const LoadingWidget();
    }
  }
}