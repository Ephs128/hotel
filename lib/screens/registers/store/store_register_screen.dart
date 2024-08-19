import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/store_model.dart';
import 'package:hotel/data/service/store_service.dart';
import 'package:hotel/screens/error_screen.dart';
import 'package:hotel/screens/registers/store/store_form_screen.dart';
import 'package:hotel/screens/registers/widgets/tables/store_table_widget.dart';
import 'package:hotel/screens/widgets/loading_widget.dart';

class StoreRegisterScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;

  const StoreRegisterScreen({
    super.key, 
    required this.changeScreenTo
  });

  @override
  State<StoreRegisterScreen> createState() => _StoreRegisterScreenState();
}

class _StoreRegisterScreenState extends State<StoreRegisterScreen> {
  List<Store> stores = [];
  bool isLoaded = false;
  Data<List<Store>>? result;

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  Future<void> _fetchStores() async {
    final storeService = StoreService();
    result = await storeService.getAllStores();
    stores = result!.data ?? [];
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded) {
      return result!.data == null ?
        ErrorScreen(message: result!.message)
      : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton(
            child: const Icon(FluentIcons.add_medium),
            onPressed: () {
              widget.changeScreenTo(
                StoreFormScreen(
                  changeScreenTo: widget.changeScreenTo,
                )
              );
            }, 
          ),
          const SizedBox(height: 20,),
          StoreTableWidget(
            storeList: stores,
            changeScreenTo: widget.changeScreenTo,
          ),
        ],
      );
    } else {
      return const LoadingWidget();
    }
  }
}