import 'package:flutter/material.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/data/service/login_service.dart';
import 'package:hotel/screens/mobile/error_view.dart';
import 'package:hotel/screens/mobile/rooms/rooms_view.dart';

import 'package:hotel/screens/mobile/widgets/dialogs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final GlobalKey<FormState> _loginFormState = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> sendPostRequest(BuildContext context) async {
    showLoaderDialog(context);
      String user = _nameController.text;
      String password = _passwordController.text;
      final loginService = LoginService();
      Data<Login> result = await loginService.postLogin(user, password);
      
    if (context.mounted) closeLoaderDialog(context);

    if (result.data == null) {
      if (context.mounted) {
        showMessageDialog(
          context: context, 
          title: "Error",
          message: result.message
        );
      }
    } else {
      if (context.mounted) {
        toHome(context, result.data!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _loginFormState,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Nombre usuario"),
                TextFormField(
                  validator: emptyValidator,
                  controller: _nameController,
                ),
                const SizedBox(height: 10,),
                const Text("Contraseña"),
                TextFormField(
                  validator: emptyValidator,
                  controller: _passwordController,
                ),
                const SizedBox(height: 30,),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_loginFormState.currentState!.validate()) {
                        sendPostRequest(context);
                      }
                    }, 
                    child: const Text("Iniciar sesión")
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? emptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Campo obligatorio";
    }
    return null;
  }

  void toHome(BuildContext context, Login login) {
    Widget? view;
    for(Menu menu in login.menus) {
      switch(menu.menuCode) {
        case Menu.mRoomCode:
          view ??= RoomsView(
            login: login,
            menu: menu,
          );
      }
      if(view != null) {
        break;
      }
    }
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => 
          view ?? 
          const ErrorView(
            message: "No tiene permisos", 
            description: "Los permisos disponibles en dispositivos móviles no estan disponibles para su usuario.",
          ),
        )
      );
  }
}