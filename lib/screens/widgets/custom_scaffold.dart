import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/screens/error_view.dart';
import 'package:hotel/screens/loading_view.dart';
import 'package:hotel/screens/widgets/menu_widget.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CustomScaffold extends StatefulWidget {

  final String title;
  final bool isLoaded;
  final Data? data;
  final Widget Function(BuildContext context, bool internet) body;
  final MenuWidget? menuWidget;

  const CustomScaffold({
    super.key,
    required this.title,
    required this.isLoaded,
    required this.data,
    required this.body,
    this.menuWidget,
  });

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {

  bool _internetConnected = false;
  bool _firstTime = true;
  bool _showBar = false;
  StreamSubscription? _internetSuscription;

  @override
  void initState() {
    super.initState();
    _internetSuscription = InternetConnection().onStatusChange.listen( (event) {
        switch (event) {
          case InternetStatus.connected:
            setState(() {
              _internetConnected = true;
            });
            if (_firstTime) {
              _firstTime = false;
            } else {
              _showBar = true;
              Future.delayed(const Duration(seconds: 3)).then((_) {
                setState(() {
                  _showBar = false;
                });
              });
            }
          case InternetStatus.disconnected:
            setState(() {
              _showBar = true;
              _internetConnected = false;
            });
          default:
            setState(() {
              _internetConnected = false;
            });
        }
    } );
  }

  @override
  void dispose() {
    _internetSuscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("ccustom scaffold values");
    log("internet connected: $_internetConnected");
    log("loaded: ${widget.isLoaded}");
    log("data result: ${widget.data?.message}");
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.title),
            if(_showBar) Expanded(
              child: Container(
                color: _internetConnected ? Colors.green: Colors.red, 
                child: _internetConnected ? const Text("De vuelta en linea") : const Text("Sin conexión a internet"),))
          ],
        ),
      ),
      body:widget.isLoaded ? 
        const LoadingView() 
      : widget.data!.data == null ? 
        ErrorView(message: widget.data!.message)
        : widget.body(context, _internetConnected),
      drawer: widget.menuWidget,
    );
  }
}