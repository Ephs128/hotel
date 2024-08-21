import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/store_model.dart';
import 'package:hotel/data/service/store_service.dart';
import 'package:hotel/screens/error_screen.dart';
import 'package:hotel/screens/registers/store/store_form_screen.dart';
import 'package:hotel/screens/registers/widgets/tables/store_table_widget.dart';
import 'package:hotel/screens/widgets/loading_widget.dart';

import 'package:hotel/screens/widgets/dialog_functions.dart' as dialog_function;

class StoreRegisterScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;
  final String? withSuccessMessage;
  final String? withErrorMessage;

  const StoreRegisterScreen({
    super.key, 
    required this.changeScreenTo,
    this.withSuccessMessage,
    this.withErrorMessage,
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
            reload: () {
              setState(() {
                isLoaded = false;
              });
              _fetchStores();
            },
          ),
        ],
      );
    } else {
      return const LoadingWidget();
    }
  }
}