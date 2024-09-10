import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/widgets/room_card_widget.dart';
import 'package:responsive_grid/responsive_grid.dart';

class RoomsScreen extends StatefulWidget {

  final Function(Widget) changeScreenTo;
  final String? withSuccessMessage;
  final String? withErrorMessage;

  const RoomsScreen({
    super.key, 
    required this.changeScreenTo, 
    this.withSuccessMessage, 
    this.withErrorMessage,
  });

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ResponsiveGridList(
        desiredItemWidth: 200,
        minSpacing: 20,
        children: [
          RoomCardWidget(
            room: Room(
              id: 5, 
              name: "H01", 
              description: "description", 
              position: "position", 
              type: 0, 
              price: 125, 
              state: true
            ), 
            state: 0,
            changeScreenTo: widget.changeScreenTo,
          ),
          RoomCardWidget(
            room: Room(
              id: 5, 
              name: "H02", 
              description: "description", 
              position: "position", 
              type: 0, 
              price: 125, 
              state: true
            ), 
            state: 1,
            changeScreenTo: widget.changeScreenTo,
          ),
          RoomCardWidget(
            room: Room(
              id: 5, 
              name: "H03", 
              description: "description", 
              position: "position", 
              type: 0, 
              price: 125, 
              state: true
            ), 
            state: 2,
            changeScreenTo: widget.changeScreenTo,
          ),
          RoomCardWidget(
            room: Room(
              id: 5, 
              name: "H04", 
              description: "description", 
              position: "position", 
              type: 0, 
              price: 125, 
              state: true
            ), 
            state: 3,
            changeScreenTo: widget.changeScreenTo,
          ),
        ],
      ),
    );
  }
}
