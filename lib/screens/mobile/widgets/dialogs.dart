import 'package:flutter/material.dart';

void showConfirmationDialog(
  {
    required BuildContext context,
    String title = "Confirmar", 
    required String message,
    required void Function() onConfirmation,
  }) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text("No")
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirmation();
              }, 
              child: const Text("Sí")
            )
          ],
        );
      },
    );
  }

void showMessageDialog(
  {
    required BuildContext context,
    String title = "Aviso", 
    required String message,
  }) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text("Cerrar")
            ),
          ],
        );
      },
    );
  }

void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Cargando..."),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void closeLoaderDialog(BuildContext context) {
    Navigator.pop(context);
  }