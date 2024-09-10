import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/widgets/tables/table_cells/normal_table_cell.dart';

class StateTableCell extends StatelessWidget {
  
  final bool status;
  final String activeLabel;
  final String? inactiveLabel;
  final Color activeColor;
  final Color inactiveColor;

  const StateTableCell({
    super.key, 
    required this.status, 
    required this.activeLabel, 
    required this.activeColor, 
    required this.inactiveColor,
    this.inactiveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return NormalTableCell(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
          decoration: BoxDecoration(
            color: status ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: status ? Text(activeLabel) : Text(inactiveLabel?? activeLabel),
        ),
      )
    );
  }
}