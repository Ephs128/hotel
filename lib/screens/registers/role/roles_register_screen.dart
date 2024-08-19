import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/data/service/role_service.dart';
import 'package:hotel/screens/error_screen.dart';
import 'package:hotel/screens/registers/role/role_form_screen.dart';
import 'package:hotel/screens/registers/widgets/tables/roles_table_widget.dart';
import 'package:hotel/screens/widgets/loading_widget.dart';

class RolesRegisterScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;
  
  const RolesRegisterScreen({
    super.key, 
    required this.changeScreenTo,
  });

  @override
  State<RolesRegisterScreen> createState() => _RolesRegisterScreenState();
}

class _RolesRegisterScreenState extends State<RolesRegisterScreen> {
  List<Role> roles = [];
  bool isLoaded = false;
  Data<List<Role>>? result;

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  Future<void> _fetchRoles() async {
    final roleService = RoleService();
    result = await roleService.getAllRoles();
    roles = result!.data ?? [];
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded){
      return  result!.data == null ?
        ErrorScreen(message: result!.message)
      : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton(
            child: const Icon(FluentIcons.add_medium),
            onPressed: () {
              widget.changeScreenTo(
                const RoleFormScreen()
              );
            },
          ),
          const SizedBox(height: 20,),
          RolesTableWidget(roleList: roles),
        ],
      );
    } else {
      return const LoadingWidget();
    }
  }
}