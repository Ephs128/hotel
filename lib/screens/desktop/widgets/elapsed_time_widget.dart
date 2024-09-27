import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';

class ElapsedTimeWidget extends StatefulWidget {

  final DateTime time;
  final TextStyle? style;

  const ElapsedTimeWidget({
    super.key,
    required this.time,
    this.style,
  });

  @override
  State<ElapsedTimeWidget> createState() => _ElapsedTimeWidgetState();
}

class _ElapsedTimeWidgetState extends State<ElapsedTimeWidget> {

  Timer? _timer;
  String oldTime = "";
  String newTime = "";
  Duration? _elapsedTime;
  
  @override
  void initState() {
    super.initState();
    _elapsedTime = DateTime.now().difference(widget.time);
    oldTime = format(_elapsedTime!);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _elapsedTime = DateTime.now().difference(widget.time);
      newTime = format(_elapsedTime!);
      if (newTime != oldTime) {
        setState(() {
          oldTime = newTime;
        });
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