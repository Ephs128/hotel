import 'package:flutter/material.dart';
import 'package:hotel/screens/mobile/login_view.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
          children: [
            const SizedBox(
              height: 80,
              child: DrawerHeader(
                margin: EdgeInsets.only(bottom: 5),
                child: Text("Company name", style: TextStyle(fontSize: 24),),
              ),
            ),
            ListTile(
              leading: Icon(MdiIcons.homeVariant),
              title:  const Text("Habitaciones"),
              onTap: () {
                Navigator.pop(context); // ? Close drawer first
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.store),
              title:  const Text("Productos"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.fileTableOutline),
              title:  const Text("Reportes"),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
            const Spacer(),
            const Divider(color: Colors.black45,),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ListTile(
                leading: Icon(MdiIcons.logout),
                title:  const Text("Cerrar Sesión"),
                onTap: () {
                  Navigator.pop(context); 
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (context) => const LoginView()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
          ],
        ),
    );
  }
}