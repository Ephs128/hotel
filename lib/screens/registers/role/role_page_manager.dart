import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/registers/role/roles_register_screen.dart';

class RolePageManager extends StatefulWidget {
  const RolePageManager({super.key});

  @override
  State<RolePageManager> createState() => _RolePageManagerState();
}

class _RolePageManagerState extends State<RolePageManager> {
  Widget? selectedPage;
  
  void changeScreenTo(Widget screen) {
    setState(() {
      selectedPage = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedPage ??= RolesRegisterScreen(changeScreenTo: changeScreenTo);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: selectedPage,
      ),
    );
  }
}