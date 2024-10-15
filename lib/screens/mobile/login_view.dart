import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/data/service/login_service.dart';
import 'package:hotel/screens/mobile/rooms/rooms_view.dart';

import 'package:hotel/screens/mobile/widgets/dialogs.dart';
import 'package:hotel/screens/mobile/without_options.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hotel/data/env.dart';//! borrar

class LoginView extends StatefulWidget {
  final String? message;
  final String? titleMessage;
  
  const LoginView({
    super.key,
    this.message,
    this.titleMessage,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final GlobalKey<FormState> _loginFormState = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ipController = TextEditingController(); //! borrar
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool showPassword = false;

  Future<void> sendPostRequest(BuildContext context) async {
    showLoaderDialog(context);
      baseURL = _ipController.text;
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.message != null) {
        if (widget.titleMessage == null) {
          showMessageDialog(context: context, message: widget.message!);
        } else {
          showMessageDialog(context: context, title: widget.titleMessage!, message: widget.message!);
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _ipController.dispose(); //! borrar
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ipController.text = baseURL; //! borrar
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
                const Text("ip"),
                TextFormField(
                  controller: _ipController,
                ),
                const SizedBox(height: 10,),
                const Text("Nombre usuario"),
                TextFormField(
                  validator: (value) => _validator(value, 5, 19),
                  controller: _nameController,
                ),
                const SizedBox(height: 10,),
                const Text("Contraseña"),
                // Row(
                  // children: [
                    TextFormField(
                      obscureText: !showPassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      validator: (value) => _validator(value, 3, 9),
                      controller: _passwordController,
                    ),
                //     IconButton(
                //       onPressed: () {
                //         setState(() {
                //           showPassword = !showPassword;
                //         });
                //       }, 
                //       icon: Icon(showPassword ? MdiIcons.eye : MdiIcons.eyeOff)
                //     ),
                //   ]
                // ),
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

  String? _validator(String? value, int min, int max) {
    if (value == null || value.isEmpty) {
      return "Campo obligatorio";
    } else {
      int length = value.length;
      if (length > max) {
        return "Ha ingresado demasiados caracteres, máximo $max";
      } else if (length < min) {
        return "Ha ingresado muy pocos caracteres, mínimo $min";
      }
    }
    return null;
  }

  void toHome(BuildContext context, Login login) async {
    Widget? view;
    for(Menu menu in login.menus) {
      switch(menu.menuCode) {
        case Menu.mRoomCode:
        if (view == null) {
          view = RoomsView(
            login: login,
            menu: menu,
          );
          await storage.write(
            key: "menu", 
            value: jsonEncode(menu.toJson()),
          );
        }
      }
      if(view != null) {
        break;
      }
    }
    if (context.mounted){
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => view ?? WithoutOptions(login: login)
        )
      );
    }
  }
}