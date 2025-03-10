import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/login_model.dart';
import 'package:hotel/data/models/menu_model.dart';
import 'package:hotel/data/service/login_service.dart';
import 'package:hotel/env.dart';
import 'package:hotel/screens/login_view.dart';
import 'package:hotel/screens/rooms/rooms_view.dart';
import 'package:hotel/screens/widgets/dialogs.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class MenuWidget extends StatefulWidget {

  final Env env;
  final Login login;
  final String selectedMenuCode;

  const MenuWidget({
    super.key, 
    required this.env,
    required this.login, 
    required this.selectedMenuCode,
  });

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {

  final ShorebirdUpdater _updater = ShorebirdUpdater();
  late final bool _isUpdaterAvailable;
  UpdateTrack _currentTrack = UpdateTrack.stable;
  bool _isCheckingForUpdates = false;
  Patch? _currentPatch;

  @override
  void initState() {
    super.initState();
    // Check whether Shorebird is available.
    setState(() => _isUpdaterAvailable = _updater.isAvailable);

    // Read the current patch (if there is one.)
    // `currentPatch` will be `null` if no patch is installed.
    _updater.readCurrentPatch().then((currentPatch) {
      setState(() => _currentPatch = currentPatch);
    }).catchError((Object error) {
      // If an error occurs, we log it for now.
      debugPrint('Error reading current patch: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tiles = [
      const SizedBox(height: 30,),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          
          children: [
            Image(image: AssetImage('${widget.env.assetsPath}/logo.png'), height: 50,),
            Text(widget.env.appName, style: const TextStyle(fontSize: 24),),
            Text(widget.env.version, style: const TextStyle(color: Colors.blueGrey),),
          ]
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
                  MaterialPageRoute(builder: (context) => RoomsView(env: widget.env, login: widget.login, menu: menu)),
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
          leading: Icon(MdiIcons.cellphoneArrowDown),
          title:  const Text("Buscar actualizaciones"),
          onTap: null,
        ),
      )
    );
    tiles.add(
      Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: ListTile(
          leading: Icon(MdiIcons.logout),
          title:  const Text("Cerrar Sesión"),
          onTap: () {
            _logout(context);
          },
        ),
      )
    );
    return Drawer(
      child: Column(children: tiles),
    );
  }

  Future<void> _checkForUpdate() async {
    if (_isCheckingForUpdates) return;

    try {
      setState(() {
        _isCheckingForUpdates = true;
      });
      final status = await _updater.checkForUpdate(track: _currentTrack);
      if (!mounted) return;
      switch (status) {
        case UpdateStatus.upToDate:
        
        case UpdateStatus.outdated:

        case UpdateStatus.restartRequired:

        case UpdateStatus.unavailable:

      }
    } catch (error) {
      // If an error occurs, we log it for now.
      debugPrint('Error checking for update: $error');
    } finally {
      setState(() => _isCheckingForUpdates = false);
    }
  }

  void _logout(BuildContext context) async {
    showLoaderDialog(context);
    log("loggin out");
    LoginService loginService = LoginService(env: widget.env);
    Data<String> result = await loginService.postLogout(widget.login.user);
    if (context.mounted) {
      closeLoaderDialog(context);
      
      if (result.data != null) {
        log("ready to getBack");
        Navigator.pop(context); 
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => LoginView(env: widget.env)),
          (Route<dynamic> route) => false,
        );
      } else {
        log("there was an error");
        Navigator.pop(context); 
        showMessageDialog(
          context: context, 
          title: "Hubo un error",
          message: result.message
        );
      }
    }
  }
}