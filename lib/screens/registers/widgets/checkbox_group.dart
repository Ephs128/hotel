import 'package:fluent_ui/fluent_ui.dart';

class CheckboxGroup<T> extends StatefulWidget {
  
  final Map<T, bool> mapPairs;
  final bool readOnly;

  const CheckboxGroup({
    super.key,
    required this.mapPairs,
    required this.readOnly,
  });

  @override
  State<CheckboxGroup<T>> createState() => _CheckboxGroupState<T>();

}

class _CheckboxGroupState<T> extends State<CheckboxGroup<T>> {
  @override
  Widget build(BuildContext context) {
    List<Widget> checkboxes = [];
    widget.mapPairs.forEach((k, v) {
      checkboxes.add(Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(k.toString()),
            ),
            Flexible(
              child: Checkbox(
                checked: v, 
                onChanged: widget.readOnly ? null : (value) {
                  setState(() {
                    widget.mapPairs[k] = !v;
                  });
                }
              ),
            ),
          ],
        ),
      ));
    });

    return Column(
      children: checkboxes,
    );
  }


}