import 'package:fluent_ui/fluent_ui.dart';

class FooterFormWidget extends StatelessWidget {
  final Function() submit;
  final Function() cancel;
  final bool readOnly;

  const FooterFormWidget({
    super.key, 
    required this.submit, 
    required this.cancel,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (!readOnly)
          FilledButton(
            onPressed: submit,
            child: const Text("Aceptar"), 
          ),
        FilledButton(
          onPressed: cancel,
          child: const Text("Cancelar"), 
        ),
      ],
    );
  }
}