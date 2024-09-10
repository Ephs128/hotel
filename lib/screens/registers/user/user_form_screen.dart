import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/role_model.dart';
import 'package:hotel/data/models/store_model.dart';
import 'package:hotel/data/models/user_cashbox_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/models/user_store_model.dart';
import 'package:hotel/data/service/cashbox_service.dart';
import 'package:hotel/data/service/role_service.dart';
import 'package:hotel/data/service/store_service.dart';
import 'package:hotel/data/service/user_service.dart';
import 'package:hotel/screens/error_screen.dart';
import 'package:hotel/screens/registers/user/users_register_screen.dart';
import 'package:hotel/widgets/checkbox_group.dart';
import 'package:hotel/widgets/forms/header_form_widget.dart';
import 'package:hotel/widgets/loading_widget.dart';

import 'package:hotel/widgets/dialog_functions.dart' as dialog_function;

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

  final userService = UserService();

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
      int length = value.length;
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
    if (_isLoaded){
      late String title;
      final Map<String, void Function()> actionsList = {};
      switch(_formType()) {
        case 0:
          title = "Nuevo usuario";
          actionsList["Crear Nuevo"] = () {
            if (_userFormState.currentState!.validate()){
              createFunction(context);
            }
          };
          actionsList["Cancelar"] = () => backFunction();
        case 1:
          title = "Ver usuario";
          actionsList["Volver"] = () => backFunction();
        case 2:
          title = "Modificar usuario";
          actionsList["Guardar cambios"] = () {
            if (_userFormState.currentState!.validate()){
              updateFunction(context);
            }
          };
          actionsList["Cancelar"] = () => backFunction();
      }
      if (widget.user != null) {
        name.text = widget.user!.person.name;
        firstLastname.text = widget.user!.person.firstLastname;
        secondLastname.text = widget.user!.person.secondLastname ?? "";
        identityDocumentation.text = widget.user!.person.identityDocument;
        email.text = widget.user!.person.email;
        user.text = widget.user!.user;
        phone.text = widget.user!.person.phone;
        address.text = widget.user!.person.address;
        password.text = widget.user!.password;
        selectedRole = widget.user!.role;
        _updateMapBoolStore(storeMap, widget.user!.stores);
        _updateMapBoolCashbox(cashboxMap, widget.user!.cashboxes);
      }
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
                          child: widget.readOnly ?
                          TextFormBox(
                            initialValue: selectedRole!.role,
                            readOnly: true,
                          )
                          : 
                          ComboBox<Role>(
                            isExpanded: true,
                            value: selectedRole,
                            items: roleList.map<ComboBoxItem<Role>>((e) {
                              return ComboBoxItem<Role>(
                                value: e,
                                child: Text(e.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [ for(String name in actionsList.keys) 
                    FilledButton(
                      onPressed: actionsList[name],
                      child: Text(name), 
                    ),
                  ],
                ),
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

  void _updateMapBoolStore(Map<Store, bool> mapBool, List<UserStore> listSelected) {
    for(UserStore userStore in listSelected) {
      for(Store store in mapBool.keys) {
        if(store.id == userStore.idStore) {
          mapBool[store] = true;
          break;
        }
      }
    }
  }

  void _updateMapBoolCashbox(Map<Cashbox, bool> mapBool, List<UserCashbox> listSelected) {
    for(UserCashbox userCashbox in listSelected) {
      for(Cashbox cashbox in mapBool.keys) {
        if(cashbox.id == userCashbox.idCashbox) {
          mapBool[cashbox] = true;
          break;
        }
      }
    }
  }

  Future<void> createFunction(BuildContext context) async {
    dialog_function.showLoaderDialog(context);
    List<Cashbox> listCashboxes = [];
    List<Store> listStores = [];
    for (Cashbox cashbox in cashboxMap.keys) {
      if (cashboxMap[cashbox]!) {
        listCashboxes.add(cashbox);
      }
    }
    for (Store store in storeMap.keys) {
      if (storeMap[store]!) {
        listStores.add(store);
      }
    }
    Data<String> result = await userService.createUser(
      name.text, 
      firstLastname.text, 
      secondLastname.text, 
      identityDocumentation.text, 
      phone.text, 
      email.text, 
      address.text, 
      user.text, 
      password.text, 
      "", 
      "", 
      selectedRole!, 
      listCashboxes, 
      listStores
    );
    if (context.mounted) dialog_function.closeLoaderDialog(context);

    if (result.data == null) {
      if (context.mounted) dialog_function.showInfoDialog(context, "Error", result.message);
    } else {
      widget.changeScreenTo(
        UsersRegisterScreen(
          changeScreenTo: widget.changeScreenTo,
          withSuccessMessage: result.data,
        )
      );
    }
  }

  Future<void> updateFunction(BuildContext context) async {
    // Store store = Store(
    //   id: widget.store!.id, 
    //   name: name.text, 
    //   state: widget.store!.state
    // );
    // dialog_function.showLoaderDialog(context);
    // Data<String> result = await storeService.updateStore(store);
    // if (context.mounted) dialog_function.closeLoaderDialog(context);

    // if (result.data == null) {
    //   if (context.mounted) dialog_function.showInfoDialog(context, "Error", result.message);
    // } else {
    //   if (context.mounted) dialog_function.showInfoDialog(context, "Operación exitosa", result.data!);
    // }
  }

  int _formType() {
    int type = 0;
    if(widget.user != null) {
      if (widget.readOnly) {
        type = 1;
      } else {
        type = 2;
      }
    }
    return type;
  }
}