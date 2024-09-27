import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/normal_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_constants.dart' as constants;

class ActionsTableCell extends StatelessWidget {
  final Function()? onSeePressed;
  final Function()? onEditPressed;
  final Function()? onDeletePressed; 
  
  const ActionsTableCell({
    super.key, 
    this.onSeePressed, 
    this.onEditPressed, 
    this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return NormalTableCell(
      child: Row(
        children: [
          FilledButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(constants.seeButtonBackground),
              foregroundColor: WidgetStatePropertyAll<Color>(constants.seeButtonForegorund) ),
            onPressed: onSeePressed,
            child: const Text(constants.seeButtonLabel), 
          ),
          const SizedBox(width: 10,),
          FilledButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(constants.editButtonBackground), 
              foregroundColor: WidgetStatePropertyAll<Color>(constants.editButtonForegorund) 
            ),
            onPressed: onEditPressed,
            child: const Text(constants.editButtonLabel), 
          ),
          const SizedBox(width: 10,),
          FilledButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(constants.deleteButtonBackground),
              foregroundColor: WidgetStatePropertyAll<Color>(constants.deleteButtonForegorund),
            ),
            onPressed: onDeletePressed,
            child: const Text(constants.deleteButtonLabel), 
          ),
        ],
      ),
    );
  }
}