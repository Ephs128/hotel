import 'dart:async';

import 'package:flutter/material.dart';

class ElapsedTimeWidget extends StatefulWidget {

  final DateTime time;
  final TextStyle? style;
  final void Function(int) controlMinutes;

  const ElapsedTimeWidget({
    super.key,
    required this.time,
    this.style, 
    required this.controlMinutes,
  });

  @override
  State<ElapsedTimeWidget> createState() => _ElapsedTimeWidgetState();
}

class _ElapsedTimeWidgetState extends State<ElapsedTimeWidget> {

  Timer? _timer;
  String oldTime = "";
  String newTime = "";
  
  @override
  void initState() {
    super.initState();
    Duration elapsedTime = DateTime.now().difference(widget.time);
    
    oldTime = format(elapsedTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      elapsedTime = DateTime.now().difference(widget.time);
      newTime = format(elapsedTime);
      if (newTime != oldTime) {
        setState(() {
          oldTime = newTime;
        });
        widget.controlMinutes(elapsedTime.inMinutes);
      }
    });
  }

  format(Duration d) => d.toString().split('.').first.padLeft(5, "0");

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(oldTime, style: widget.style,);
  }

  // @override
  // void didUpdateWidget(ElapsedTimeWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   if(widget.time != oldWidget.time) {
  //     _initialTime = _parseTimestamp();
  //     _currentDuration = _formatDuration(_calcElapsedTime());
  //   }
  // }
}