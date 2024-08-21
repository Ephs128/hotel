import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/registers/device/device_register_screen.dart';

class DevicePageManager extends StatefulWidget {
  const DevicePageManager({super.key});

  @override
  State<DevicePageManager> createState() => _DevicePageManagerState();
}

class _DevicePageManagerState extends State<DevicePageManager> {
  Widget? selectedPage;
  
  void changeScreenTo(Widget screen) {
    setState(() {
      selectedPage = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedPage ??= DeviceRegisterScreen(changeScreenTo: changeScreenTo);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: selectedPage,
      ),
    );
  }
}