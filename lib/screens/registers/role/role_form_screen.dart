import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/data/service/menu_service.dart';
import 'package:hotel/data/service/role_service.dart';
import 'package:hotel/screens/error_screen.dart';
import 'package:hotel/screens/registers/role/roles_register_screen.dart';
import 'package:hotel/widgets/checkbox_menu_widget.dart';
import 'package:hotel/widgets/forms/footer_form_widget.dart';
import 'package:hotel/widgets/forms/header_form_widget.dart';
import 'package:hotel/widgets/loading_widget.dart';

class RoleFormScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;
  final Role? role;
  final bool readOnly;

  const RoleFormScreen({
    super.key,
    required this.changeScreenTo, 
    this.role, 
    this.readOnly = false,
  });

  @override
  State<RoleFormScreen> createState() => _RoleFormScreenState();
}

class _RoleFormScreenState extends State<RoleFormScreen> {
  final GlobalKey<FormState> _rolesFormState = GlobalKey<FormState>();
  final MenuService _menuService = MenuService();
  final RoleService _roleService = RoleService();
  late List<Menu> menuList;

  bool _isLoaded = false;
  String? errorMsg;

  final TextEditingController roleName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final menuResult = await _menuService.getAllMenus();
    if (menuResult.data != null) {
      menuList = menuResult.data!;

    } else {
      errorMsg = menuResult.message;
    }
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded){
      final String title = _createTitle();
      if (widget.role != null) {
        roleName.text = widget.role!.role;
      }

      return errorMsg != null ?
        ErrorScreen(message: errorMsg!)
      : Form(
          key: _rolesFormState,
          child: Column(
            children: [
              HeaderFormWidget(
                back: () => backFunction(), 
                title: title),
              const SizedBox(height: 30,),
              InfoLabel(
                label: "Nombre",
                child: TextFormBox(
                  readOnly: widget.readOnly,
                  controller: roleName,
                  expands: false,
                ),
              ),
              const SizedBox(height: 30,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flexible(
                  //   child: CheckboxTreeWidget(treeData: configurationData),
                  // ),
                  // Flexible(
                  //   child: CheckboxTreeWidget(treeData: cuentaData),
                  // ),
                  // Flexible(
                  //   child: CheckboxTreeWidget(treeData: sellsData),
                  // ),
                  for (Menu menu in menuList)
                    Flexible(
                      child: CheckboxMenuWidget(menu: menu),
                    ),
                ],
              ),
              const SizedBox(height: 30,),
              FooterFormWidget(
                submit: () {}, 
                cancel: () {backFunction();},
                readOnly: widget.readOnly,
              ),
            ],
          ),
        );
    } else {
      return const LoadingWidget();
    }
  }

  void backFunction() {
    widget.changeScreenTo(RolesRegisterScreen(changeScreenTo: widget.changeScreenTo));
  }

  String _createTitle() {
    String title = "Nuevo ";
      if(widget.role != null) {
        if (widget.readOnly) {
          title = "Ver ";
        } else {
          title = "Editar ";
        }
      }
      title += "rol";
      return title;
  }

}