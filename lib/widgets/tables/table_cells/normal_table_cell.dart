import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/widgets/tables/table_constants.dart' as constants;

class NormalTableCell extends StatelessWidget {
  final Widget child;
  const NormalTableCell({
    super.key, 
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: DefaultTextStyle(
          style: const TextStyle(color: constants.tableForeground),
          child: child),
      ),
    );
  }
}