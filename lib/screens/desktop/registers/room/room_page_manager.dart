import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/desktop/registers/room/room_register_screen.dart';

class RoomPageManager extends StatefulWidget {
  const RoomPageManager({super.key});

  @override
  State<RoomPageManager> createState() => _RoomPageManagerState();
}

class _RoomPageManagerState extends State<RoomPageManager> {
  Widget? selectedPage;

  void changeScreenTo(Widget screen) {
    setState(() {
      selectedPage = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedPage ??= RoomRegisterScreen(changeScreenTo: changeScreenTo);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: selectedPage,
      ),
    );
  }
}