import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/desktop/registers/user/users_register_screen.dart';

class UserPageManager extends StatefulWidget {
  const UserPageManager({super.key});

  @override
  State<UserPageManager> createState() => _UserPageManagerState();
}

class _UserPageManagerState extends State<UserPageManager> {

  Widget? _selectedPage;

  void changeScreenTo(Widget screen) {
    setState(() {
      _selectedPage = screen;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    _selectedPage ??= UsersRegisterScreen(changeScreenTo: changeScreenTo);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: _selectedPage,
      ),
    );
  }
}