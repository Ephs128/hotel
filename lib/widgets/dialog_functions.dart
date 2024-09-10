import 'package:fluent_ui/fluent_ui.dart';

void showLoaderDialog(BuildContext context) {
  ContentDialog alert = ContentDialog(
    content: Row(
      children: [
        const ProgressRing(),
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

void showInfoDialog(BuildContext context, String title, String message) {
  ContentDialog alert = ContentDialog(
    title: Text(title),
    content: Text(message),
    style: ContentDialogThemeData(
      barrierColor: Colors.red.lightest,
      actionsPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
    ),
    actions: [
      FilledButton(
        child: const Text("Ok"),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    });
}

void showConfirmationDialog(BuildContext context, String title, String message, Function() onAccept) {
  ContentDialog alert = ContentDialog(
    title: Text(title),
    content: Text(message),
    style: ContentDialogThemeData(
      barrierColor: Colors.red.lightest,
      actionsPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
    ),
    actions: [
      FilledButton(
        child: const Text("Ok"),
        onPressed: () {
          onAccept();
          Navigator.pop(context);
        },
      ),
      FilledButton(
        child: const Text("cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    });
}

