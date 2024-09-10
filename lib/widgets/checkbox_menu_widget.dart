import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/menu_model.dart';

class CheckboxMenuWidget extends StatefulWidget {
  final Menu menu;
  final Function()? update;

  const CheckboxMenuWidget({
    super.key, 
    required this.menu,
    this.update,
  });

  @override
  State<CheckboxMenuWidget> createState() => _CheckboxMenuWidgetState();
}

class _CheckboxMenuWidgetState extends State<CheckboxMenuWidget> {
  
  @override
  Widget build(BuildContext context) {
    List<Widget> subitemList = [];
    for (Menu submenu in widget.menu.submenus) {
      subitemList.add(
        CheckboxMenuWidget(
          menu: submenu,
          update: widget.update ?? () {
            setState(() {
              widget.menu.calculateSelectedValue();
            });
          },
        )
      );
    }
    for (String action in widget.menu.actions.keys) {
      subitemList.add(
        Container(
          padding: const EdgeInsets.all(4),
          child: CustomCheckbox(
            label: action,
            checked: widget.menu.actions[action], 
            onChanged: (value) {
              widget.menu.updateAction(action, value ?? false);
              setState(() {
                if (widget.update != null) {
                  widget.update!();
                } else {
                  widget.menu.calculateSelectedValue();
                }
              });
            },
          ),
        )
      );
    }
    return Expander(
      initiallyExpanded: true,
      header: Container(
        padding: const EdgeInsets.all(8),
        child: CustomCheckbox(
          label: widget.menu.description,
          checked: widget.menu.selected, 
          onChanged: (value) {
            bool newValue = value ?? false;
            widget.menu.setState(newValue);
            setState(() {
              if (widget.update != null) {
                widget.update!();
              } else {
                widget.menu.calculateSelectedValue();
              }
            });
          }
        ),
      ),
      content: Column(
        children: subitemList,
      ),
    );
  }
}
class CustomCheckbox extends StatelessWidget {
  final String label;
  final bool? checked;
  final Function(bool?) onChanged;

  const CustomCheckbox({
    super.key, 
    required this.label, 
    this.checked, 
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label, 
          ),
        ),
        Flexible(
          child: Checkbox(
            checked: checked, 
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}