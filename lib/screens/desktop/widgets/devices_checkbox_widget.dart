import 'package:flutter/material.dart';
import 'package:hotel/data/models/device_model.dart';
import 'package:responsive_grid/responsive_grid.dart';

class DevicesCheckboxWidget extends StatefulWidget {

  final Map<Device, bool> devices;
  final bool readOnly;

  const DevicesCheckboxWidget({
    super.key,
    required this.devices,
    this.readOnly = false,
  });

  @override
  State<DevicesCheckboxWidget> createState() => _DevicesCheckboxWidgetState();
}

class _DevicesCheckboxWidgetState extends State<DevicesCheckboxWidget> {
    
  @override
  Widget build(BuildContext context) {
    return ResponsiveGridList(
      desiredItemWidth: 100, 
      minSpacing: 10,
      children: widget.devices.keys.map((device) {
        return Row(
          children: [
            Expanded(child: Text(device.name)),
            Checkbox(
              value: widget.devices[device], 
              onChanged: (value) {
                setState(() {
                  widget.devices[device] = !widget.devices[device]!;
                });
              }
            ),
          ],
        );
      }).toList(),
    );
  }
}