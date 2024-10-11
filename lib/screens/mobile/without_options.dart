import 'package:flutter/material.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/service/login_service.dart';
import 'package:hotel/screens/mobile/login_view.dart';
import 'package:hotel/screens/mobile/widgets/dialogs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class WithoutOptions extends StatelessWidget {
  final Login login;

  const WithoutOptions({
    super.key, 
    required this.login
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.accountAlert, 
            color: Colors.red, 
            size: 90,
          ),
          const SizedBox(height: 30,),
          const Text(
            "No tiene permisos",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30,),
          Text(
            "Los permisos disponibles en dispositivos móviles no estan disponibles para su usuario.",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[130]
            ),
          ),
          const SizedBox(height: 30,),
          ElevatedButton(
            onPressed: () => logout(context), 
            child: const Text("Cerrar sesión")
          ),
        ],
      )
    );
  }

  void logout(BuildContext context) async {
    showLoaderDialog(context);
    LoginService loginService = LoginService();
    Data<String> result = await loginService.postLogout(login.user);
    if (context.mounted) {
      closeLoaderDialog(context);
      
      if (result.data != null) {
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => const LoginView()),
          (Route<dynamic> route) => false,
        );
      } else {
        showMessageDialog(
          context: context, 
          title: "Hubo un error",
          message: result.message
        );
      }
    }
  }
}