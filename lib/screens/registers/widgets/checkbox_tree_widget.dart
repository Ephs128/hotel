import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/registers/role/permission_tree_data.dart';

class CheckboxTreeWidget extends StatefulWidget {
  final ParentTreeData treeData;

  const CheckboxTreeWidget({
    super.key, 
    required this.treeData, 
  });

  @override
  State<CheckboxTreeWidget> createState() => _CheckboxTreeWidgetState();
}

class _CheckboxTreeWidgetState extends State<CheckboxTreeWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Expander(
      initiallyExpanded: true,
      header: Container(
        padding: const EdgeInsets.all(8),
        child: CustomCheckbox(
          label: widget.treeData.title,
          checked: widget.treeData.state, 
          onChanged: (value) {
            setState(() {
              widget.treeData.changeState();
            });
          }
        ),
      ),
      content: Column(
        children: [
          for (ChildTreeData child in widget.treeData.children)
            Expander(
              header: Container(
                padding: const EdgeInsets.all(8),
                child: CustomCheckbox(
                  label: child.title,
                  checked: child.state, 
                  onChanged: (value) {
                    int changed = child.changeState();
                    setState(() {
                      widget.treeData.updateSelectedCount(changed);
                    });
                  }
                ),
              ),
              content: Column(
                children: [
                  for (ValueTreeData option in child.children)
                    Container(
                      padding: const EdgeInsets.all(4),
                      child: CustomCheckbox(
                        label: option.data,
                        checked: option.selected, 
                        onChanged: (value) {
                          int changed = option.switchSelected();
                          child.updateSelected(changed);
                          setState(() {
                            widget.treeData.updateSelectedCount(changed);
                          });
                        },
                      ),
                    )
                ],
              )
            ),
        ],
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
        Text(label),
        Checkbox(
          checked: checked, 
          onChanged: onChanged,
        ),
      ],
    );
  }
}