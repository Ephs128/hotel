import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/registers/cashbox/cashbox_page_manager.dart';
import 'package:hotel/screens/registers/device/device_page_manager.dart';
import 'package:hotel/screens/registers/role/role_page_manager.dart';
import 'package:hotel/screens/registers/room/room_page_manager.dart';
import 'package:hotel/screens/registers/store/store_page_manager.dart';
import 'package:hotel/screens/registers/user/user_page_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: NavigationView(
        pane: NavigationPane(
          items: [
            PaneItem(
              icon: const Icon(FluentIcons.account_management),
              title: const Text("Usuarios"),
              body: const UserPageManager(),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.permissions),
              title: const Text("Roles"),
              body: const RolePageManager(),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.repo),
              title: const Text("Almacenes"),
              body: const StorePageManager(),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.money),
              title: const Text("Cuentas"),
              body: const CashboxPageManager(),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.home),
              title: const Text("Habitaciones"),
              body: const RoomPageManager(),
            ),
            PaneItem(
              icon: const Icon(FluentIcons.devices2),
              title: const Text("Dispositivos"),
              body: const DevicePageManager(),
            ),
          ],
          displayMode: PaneDisplayMode.top,
          selected: _currentIndex,
          onChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
      ),
    );
  }
}
