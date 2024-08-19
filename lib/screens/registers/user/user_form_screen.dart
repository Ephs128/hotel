import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/data/models/store_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/service/cashbox_service.dart';
import 'package:hotel/data/service/role_service.dart';
import 'package:hotel/data/service/store_service.dart';
import 'package:hotel/screens/error_screen.dart';
import 'package:hotel/screens/registers/user/users_register_screen.dart';
import 'package:hotel/screens/registers/widgets/checkbox_group.dart';
import 'package:hotel/screens/registers/widgets/forms/footer_form_widget.dart';
import 'package:hotel/screens/registers/widgets/forms/header_form_widget.dart';
import 'package:hotel/screens/widgets/loading_widget.dart';

class UserFormScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;
  final User? user;
  final bool readOnly;

  const UserFormScreen({
    super.key, 
    required this.changeScreenTo, 
    this.user,
    this.readOnly = false,
  });

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final GlobalKey<FormState> _userFormState = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController firstLastname = TextEditingController();
  final TextEditingController secondLastname = TextEditingController();
  final TextEditingController identityDocumentation = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController user = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController password = TextEditingController();

  final RegExp _emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',);

  List<Role> roleList = [];
  Role? selectedRole;
  Map<Store, bool> storeMap = {};
  Map<Cashbox, bool> cashboxMap = {};
  bool _isLoaded = false;
  String? errorMsg;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final roleService = RoleService();
    final storeService = StoreService();
    final cashboxService = CashboxService();

    final roleResult = await roleService.getAllRoles();
    final storeResult = await storeService.getAllStores();
    final cashboxResult = await cashboxService.getAllCashboxes();

    if (roleResult.data != null ) {
      roleList = roleResult.data!;
      if (storeResult.data != null ) {
        List<Store> listStore = storeResult.data!;
        storeMap = { for (var k in listStore) k : false };
        if (cashboxResult.data != null) {
          List<Cashbox> listCashbox = cashboxResult.data!;
          cashboxMap = { for (var k in listCashbox) k : false };
        } else {
          errorMsg = cashboxResult.message;
        }
      } else {
        errorMsg = storeResult.message;  
      }
    } else {
      errorMsg = roleResult.message;
    }

    setState(() {
      _isLoaded = true;
    });
  }


  // Validadores
  String? _emailValidator(value) {
    String? errorMsg;
    if (value == null || value.isEmpty) {
      errorMsg = 'Por favor, ingresa un correo electrónico';
    } else if (!_emailRegExp.hasMatch(value)) {
      errorMsg = 'Por favor, ingresa un correo electrónico válido';
    }
    return errorMsg;
  }

  String? _idValidator(value) {
    String? errorMsg;
    if (value == null || value.isEmpty) {
      errorMsg = 'Por favor, ingresa un cedula de identidad';
    } else {
      int length = errorMsg!.length;
      if (length < 7) {
        errorMsg = 'La cedula de identidad debe tener 7 digitos';
      } else if (length > 8) {
        errorMsg = 'La cedula de identidad debe tener 7 digitos';
      }
    }
    return errorMsg;
  }

  @override
  Widget build(BuildContext context) {
    final String title = _createTitle();
    if (widget.user != null ) {
      name.text = widget.user!.person.name;
      firstLastname.text = widget.user!.person.firstLastname;
      secondLastname.text = widget.user!.person.secondLastname ?? "";
      identityDocumentation.text = widget.user!.person.identityDocument;
      email.text = widget.user!.person.email;
      user.text = widget.user!.user;
      phone.text = widget.user!.person.phone;
      address.text = widget.user!.person.address;
      password.text = widget.user!.password;
    }

    if (_isLoaded){
      selectedRole ??= roleList.first;
      return errorMsg != null ? 
        ErrorScreen(message: errorMsg!)
      : Form(
          key: _userFormState,
          child: Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                HeaderFormWidget(
                  back: () => backFunction(), 
                  title: title,
                ),
                const SizedBox(height: 30,),
                Row(
                  children: [
                    Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48),
                          child: Column(
                            children: [
                              InfoLabel(
                                label: "Nombre",
                                child: TextFormBox(
                                  readOnly: widget.readOnly,
                                  controller: name,
                                  expands: false,
                                ),
                              ),
                              const SizedBox(height: 16,),
                              InfoLabel(
                                label: "Apellido Paterno",
                                child: TextFormBox(
                                  readOnly: widget.readOnly,
                                  controller: firstLastname,
                                  expands: false,
                                ),
                              ),
                              const SizedBox(height: 16,),
                              InfoLabel(
                                label: "Apellido Materno",
                                child: TextFormBox(
                                  readOnly: widget.readOnly,
                                  controller: secondLastname,
                                  // placeholder: 'Name',
                                  expands: false,
                                ),
                              ),
                              const SizedBox(height: 16,),
                              InfoLabel(
                                label: "CI",
                                child: TextFormBox(
                                  readOnly: widget.readOnly,
                                  controller: identityDocumentation,
                                  expands: false,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  keyboardType: TextInputType.number,
                                  maxLength: 8,
                                  validator: _idValidator,
                                ),
                              ),
                              const SizedBox(height: 16,),
                              InfoLabel(
                                label: "Correo Electrónico",
                                child: TextFormBox(
                                  readOnly: widget.readOnly,
                                  controller: email,
                                  validator: _emailValidator,
                                  expands: false,
                                ),
                              ),
                              const SizedBox(height: 16,),
                              InfoLabel(
                                label: "Usuario",
                                child: TextFormBox(
                                  readOnly: widget.readOnly,
                                  controller: user,
                                  // placeholder: 'Name',
                                  expands: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48),
                          child: Column(
                            children: [
                              
                              InfoLabel(
                                label: "Teléfono",
                                child: TextFormBox(
                                  readOnly: widget.readOnly,
                                  controller: phone,
                                  expands: false,
                                ),
                              ),
                              const SizedBox(height: 16,),
                              InfoLabel(
                                label: "Dirección",
                                child: TextFormBox(
                                  readOnly: widget.readOnly,
                                  controller: address,
                                  // placeholder: 'Name',
                                  expands: false,
                                ),
                              ),
                              const SizedBox(height: 16,),
                              if (widget.user == null)
                              InfoLabel(
                                label: "Contraseña",
                                child: PasswordFormBox(
                                  controller: password,
                                  // placeholder: 'Name',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 30,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: InfoLabel(
                        label: "Rol",
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ComboBox<Role>(
                            value: selectedRole,
                            items: roleList.map<ComboBoxItem<Role>>((e) {
                              return ComboBoxItem<Role>(
                                value: e,
                                child: Text(e.toString()),
                              );
                            }).toList(),
                            onChanged: widget.readOnly ? null :
                            (value) {
                              setState(() {
                                selectedRole = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30,),
                    Flexible(
                      flex: 1,
                      child: Expander(
                        initiallyExpanded: true,
                        header: const Text("Almacenes"),
                        content: CheckboxGroup<Store>(
                          mapPairs: storeMap, 
                          readOnly: widget.readOnly
                        ),
                      ),
                    ),
                    const SizedBox(width: 30,),
                    Flexible(
                      flex: 1,
                      child: Expander(
                        initiallyExpanded: true,
                        header: const Text("Cuentas"),
                        content: CheckboxGroup<Cashbox> (
                          mapPairs: cashboxMap,
                          readOnly: widget.readOnly,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                FooterFormWidget(
                  submit: () {}, 
                  cancel: () => backFunction(),
                  readOnly: widget.readOnly,
                )
              ],
            ),
          ),
        );
    } else {
      return const LoadingWidget();
    }
  }

  void backFunction() {
    widget.changeScreenTo(UsersRegisterScreen(changeScreenTo: widget.changeScreenTo));
  }

  String _createTitle() {
    String title = "Nuevo ";
      if(widget.user != null) {
        if (widget.readOnly) {
          title = "Ver ";
        } else {
          title = "Editar ";
        }
      }
      title += "usuario";
      return title;
  }
}