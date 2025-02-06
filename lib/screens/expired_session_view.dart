import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExpiredSessionView extends StatelessWidget {
  const ExpiredSessionView({super.key});
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        } else {
          
        }
      },
      child: Center(
        child: Column(
          children: [
            Icon(MdiIcons.accountClock),
            const Text("Su sesión expiró.", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            const Text("Por favor volver a iniciar sesion", style: TextStyle(fontSize: 20,),),
            ElevatedButton(
              onPressed: () {}, 
              child: const Text("Aceptar"),
            ),
          ],
        ),
      ),
    );
  }
}