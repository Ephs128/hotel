import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/service/room_service.dart';
import 'package:hotel/screens/desktop/error_screen.dart';
import 'package:hotel/screens/desktop/registers/room/room_form_screen.dart';

import 'package:hotel/screens/desktop/widgets/dialog_functions.dart' as dialog_function;
import 'package:hotel/screens/desktop/widgets/loading_widget.dart';

class RoomRegisterScreen extends StatefulWidget {

  final Function(Widget) changeScreenTo;
  final String? withSuccessMessage;
  final String? withErrorMessage;

  const RoomRegisterScreen({
    super.key, 
    required this.changeScreenTo, 
    this.withSuccessMessage, 
    this.withErrorMessage,
  });

  @override
  State<RoomRegisterScreen> createState() => _RoomRegisterScreenState();
}

class _RoomRegisterScreenState extends State<RoomRegisterScreen> {
  List<Room> rooms = [];
  bool isLoaded = false;
  Data<List<Room>> ? result;

  @override
  void initState() {
    super.initState();
    _fetch_devices();
    if (widget.withSuccessMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        dialog_function.showInfoDialog(context, "Operacion exitosa", widget.withSuccessMessage!);
      });
    } else {
      if (widget.withErrorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          dialog_function.showInfoDialog(context, "Error", widget.withErrorMessage!);
        });
      }
    }
  }

  Future<void> _fetch_devices() async {
    final roomService =RoomService();
    result = await roomService.getAllRooms();
    rooms = result!.data ?? [];
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded) {
      return result!.data == null ? 
        ErrorScreen(message: result!.message)
      : Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton(
              child: const Icon(FluentIcons.add_medium),
              onPressed: () {
                widget.changeScreenTo(
                  RoomFormScreen(
                    changeScreenTo: widget.changeScreenTo,
                  )
                );
              }, 
            ),
            const SizedBox(height: 20,),
          ],
        );
    } else {
      return const LoadingWidget();
    }
  }
}