import 'package:fluent_ui/fluent_ui.dart';
import 'package:responsive_grid/responsive_grid.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: const ResponsiveGridList(
        desiredItemWidth: 200,
        minSpacing: 20,
        children: [
          Text("aasdasd"),
          Text("aasdasd"),
          Text("aasdasd"),
          Text("aasdasd"),
          Text("aasdasd"),
          Text("aasdasd")
        ],
      ),
    );
  }
}
