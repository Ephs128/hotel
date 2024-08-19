import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/registers/cashbox/cashbox_register_screen.dart';

class CashboxPageManager extends StatefulWidget {
  const CashboxPageManager({super.key});

  @override
  State<CashboxPageManager> createState() => _CashboxPageManagerState();
}

class _CashboxPageManagerState extends State<CashboxPageManager> {
  Widget? _selectedPage;

  void changeScreenTo (Widget screen) {
    setState(() {
      _selectedPage = screen;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    _selectedPage ??= CashboxRegisterScreen(changeScreenTo: changeScreenTo);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: _selectedPage,
      ),
    );
  }
}