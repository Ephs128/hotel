import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/registers/store/store_register_screen.dart';

class StorePageManager extends StatefulWidget {
  const StorePageManager({super.key});

  @override
  State<StorePageManager> createState() => _StorePageManagerState();
}

class _StorePageManagerState extends State<StorePageManager> {
  Widget? selectedPage;
  
  void changeScreenTo(Widget screen) {
    setState(() {
      selectedPage = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedPage = selectedPage ?? StoreRegisterScreen(changeScreenTo: changeScreenTo);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: selectedPage,
      ),
    );
  }
}