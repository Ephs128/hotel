import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/registers/widgets/tables/table_constants.dart' as constants;

class HeaderTableCell extends StatelessWidget {
  final String text;

  const HeaderTableCell({
    super.key, 
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: constants.headerTableForeground),
          ),
        ),
      )
    );
  }
}