import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/room/rooms_screen.dart';

class RoomsPageManager extends StatefulWidget {
  const RoomsPageManager({super.key});

  @override
  State<RoomsPageManager> createState() => _RoomsPageManagerState();
}

class _RoomsPageManagerState extends State<RoomsPageManager> {

  Widget? selectedPage;

  void changeScreenTo(Widget screen) {
    setState(() {
      selectedPage = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedPage ??= RoomsScreen(changeScreenTo: changeScreenTo);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: selectedPage,
    );
  }
}