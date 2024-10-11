import 'package:flutter/material.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/data/service/login_service.dart';
import 'package:hotel/screens/mobile/login_view.dart';
import 'package:hotel/screens/mobile/rooms/rooms_view.dart';
import 'package:hotel/screens/mobile/widgets/dialogs.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MenuWidget extends StatefulWidget {
  final Login login;
  final String selectedMenuCode;

  const MenuWidget({
    super.key, 
    required this.login, 
    required this.selectedMenuCode,
  });

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {

  @override
  Widget build(BuildContext context) {
    final List<Widget> tiles = [
      const SizedBox(
        height: 80,
        child: DrawerHeader(
          margin: EdgeInsets.only(bottom: 5),
          child: Text("Company name", style: TextStyle(fontSize: 24),),
        ),
      ),
    ];
    bool selected = false;
    for(Menu menu in widget.login.menus) {
      switch(menu.menuCode) {
        case Menu.mRoomCode:
          selected = widget.selectedMenuCode == Menu.mRoomCode;
          tiles.add(ListTile(
              leading: Icon(MdiIcons.homeVariant),
              title:  const Text("Habitaciones"),
              tileColor: selected ? Colors.grey : null,
              onTap: selected ? null : () {
                Navigator.pop(context); // ? Close drawer first
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) => RoomsView(login: widget.login, menu: menu)),
                  (Route<dynamic> route) => false,
                );
              },
          ));
      }
    }
    tiles.add(const Spacer());
    tiles.add(const Divider(color: Colors.black45,));
    tiles.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: ListTile(
          leading: Icon(MdiIcons.logout),
          title:  const Text("Cerrar Sesión"),
          onTap: () {
            Navigator.pop(context); 
            _logout(context);
          },
        ),
      )
    );
    return Drawer(
      child: Column(children: tiles),
    );
  }

  void _logout(BuildContext context) async {
    showLoaderDialog(context);
    LoginService loginService = LoginService();
    Data<String> result = await loginService.postLogout(widget.login.user);
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