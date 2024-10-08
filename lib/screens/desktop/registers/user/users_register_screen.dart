import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/service/user_service.dart';
import 'package:hotel/screens/desktop/error_screen.dart';
import 'package:hotel/screens/desktop/registers/user/user_form_screen.dart';
import 'package:hotel/screens/desktop/widgets/tables/users_table.dart';
import 'package:hotel/screens/desktop/widgets/loading_widget.dart';

import 'package:hotel/screens/desktop/widgets/dialog_functions.dart' as dialog_function;

class UsersRegisterScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;
  final String? withSuccessMessage;
  final String? withErrorMessage;
  

  const UsersRegisterScreen({
    super.key, 
    required this.changeScreenTo,
    this.withSuccessMessage,
    this.withErrorMessage,
  });

  @override
  State<UsersRegisterScreen> createState() => _UsersRegisterScreenState();
}

class _UsersRegisterScreenState extends State<UsersRegisterScreen> {
  List<User> _users = [];
  bool _isLoaded = false;
  Data<List<User>>? _result;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
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

  Future<void> _fetchUsers() async {
    final userService = UserService();
    _result = await userService.getAllUsers();
    _users =  _result!.data ?? [];
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded) {
    return _result!.data == null ? 
        ErrorScreen(message: _result!.message)
      : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton(
              style: const ButtonStyle(),
              child: const Icon(FluentIcons.add_medium),
              onPressed: () {
                widget.changeScreenTo(
                  UserFormScreen(
                    changeScreenTo: widget.changeScreenTo, 
                  )
                );
              },
            ),
            const SizedBox(height: 30,),
            UsersTable(
              usersList: _users,
              changeScreenTo: widget.changeScreenTo,
              reload: () {
                setState(() {
                  _isLoaded = false;
                });
                _fetchUsers();
              },
            ),
          ],
        ),
      );
    } else {
      return const LoadingWidget();
    }
  }
}