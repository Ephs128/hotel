import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hotel/data/models/aux_sale_product_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/models/sale_product_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/service/product_service.dart';
import 'package:hotel/data/service/sale_service.dart';
import 'package:hotel/env.dart';
import 'package:hotel/screens/error_view.dart';
import 'package:hotel/screens/loading_view.dart';
import 'package:hotel/screens/store/store_products_view.dart';
import 'package:hotel/screens/widgets/dialogs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StoreView extends StatefulWidget {

  final Env env;
  final Room room;
  final User user;

  const StoreView({
    super.key, 
    required this.env,
    required this.room, 
    required this.user,
  });

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {

    // Constants
  final double _defaultFontSize = 20;
  final double _labelFontSize = 24;
  final Color _accentColor = const Color.fromRGBO(211, 211, 211, 1);
  final Color _rowColors = const Color.fromRGBO(239, 242, 247, 1);
  final Color _rowNotSavedColors = const Color.fromARGB(255, 194, 255, 199);

  late SaleService _saleService;
  late ProductService _productService;
  bool _isLoaded = false;
  late Data<List<SaleProduct>> _result;

  List<AuxSaleProduct> _recentProducts = [];

  @override
  void initState() {
    super.initState();
    _saleService = SaleService(env: widget.env);
    _productService = ProductService(env: widget.env);
    _fetchData();
  }

  void _fetchData() async {
    _result = await _productService.getProductsInSale(widget.room.product.idVenta!);
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tienda"),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didpop) => _backFunctionHandler(didpop),
        child:!_isLoaded ? 
          const LoadingView() 
        : _result.data == null ? 
          ErrorView(message: _result.message)
          : _main(),
        ),
      floatingActionButtonLocation: !_isLoaded || _result.data == null ? 
          null 
        : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !_isLoaded || _result.data == null? 
          null
        : FloatingActionButton(
          onPressed: () => _onFABClick(context),
          child: Icon(MdiIcons.plus, color: Colors.white, size: 28,),
        ),
    );
  }

  Widget _main() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.room.name, style: TextStyle(fontSize: _labelFontSize+3, fontWeight: FontWeight.bold),),
        ),
        const SizedBox(height: 10,),
        _saveButton(),
        const SizedBox(height: 30,),
        productsTableHeader(),
        Expanded(
          child: productsTableData()
        ),
        const SizedBox(height: 70,),
      ],
    );
  }

  Widget productsTableHeader() {
    return Table(
      border: const TableBorder(
        // right: BorderSide(width: 1),
        // left: BorderSide(width: 1),
        horizontalInside: BorderSide(width: 1, style:  BorderStyle.solid),
      ),
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FixedColumnWidth(70),
        2: FixedColumnWidth(50),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: _accentColor),
          children: [
            _boldCell("Producto"),
            _boldCell("Cant"),
            _boldCell(""),
          ]
        ),
      ],
    );
  }

  Widget _saveButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 38, 115, 0),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color.fromARGB(255, 162, 204, 141),
          disabledForegroundColor: Colors.grey,
        ),
        onPressed: _recentProducts.isEmpty ? null : () => _onSave(context),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text("Guardar cambios", style: TextStyle(fontSize: 22),),
        ),
      ),
    );
  }

  Widget productsTableData() {
    List<TableRow> items = [];
    for (SaleProduct saleProduct in _result.data!) {
      items.add(
        TableRow(
          decoration: BoxDecoration(color: _rowColors),
          children: [
            _normalCell(saleProduct.product.productName),
            _normalCell("1"),
            _deleteCell(() {
              _deleteSavedProduct(context, saleProduct);
            }),
          ]
        )
      );
    }
    for (AuxSaleProduct saleProduct in _recentProducts) {
      items.add(
        TableRow(
          decoration: BoxDecoration(color: _rowNotSavedColors,),
          children: [
            _normalCell(saleProduct.product.productName),
            _normalCell("1"),
            _deleteCell(() {
              setState(() {
                _recentProducts.remove(saleProduct);
              });
            }),
          ]
        )
      );
    }
    return items.isEmpty ? _emptyProducts() : SingleChildScrollView(
      child: Table(
        border: const TableBorder(
          // right: BorderSide(width: 1),
          // left: BorderSide(width: 1),
          horizontalInside: BorderSide(width: 1, style:  BorderStyle.solid),
        ),
        columnWidths: const {
          0: FlexColumnWidth(),
          1: FixedColumnWidth(70),
          2: FixedColumnWidth(50),
        },
        children: items,
      ),
    );
  }

  Widget _emptyProducts() {
    return const Center(
      child: Text("Sin productos"),
    );
  }

  Widget _normalCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(text, style: TextStyle(fontSize: _defaultFontSize),)
      )
    );
  }

  Widget _boldCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: _labelFontSize))
      ),
    );
  }

  Widget _deleteCell(Function() onDelete) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          color: Colors.red,
          child: IconButton(
            icon: Icon( MdiIcons.deleteOutline),
            color: Colors.white,
            onPressed: onDelete,
          ),
        ),
      )
    );
  }

  void _onFABClick(BuildContext context) {
    _navigateAndRetrieveSelectedProducts(context);
  }

  Future<void> _navigateAndRetrieveSelectedProducts(BuildContext context) async {
    List<AuxSaleProduct>? result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (BuildContext context) => 
        StoreProductsView(
          env: widget.env,
          room: widget.room, 
          idStore: widget.user.cashboxes.first.id,
        )
      )
    );
    if (!context.mounted) return;
    if(result != null){
      setState(() {
        _recentProducts += result;
      });
    }
  }

  void _onSave(BuildContext context) async {
    showLoaderDialog(context);
    Data<String> result = await _saleService.createSale(_result.data!, _recentProducts);
    if (context.mounted){
      closeLoaderDialog(context);
      if (result.data == null) {
        showMessageDialog(context: context, 
        title: "Error",
        message: result.message);
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _deleteSavedProduct(BuildContext context, SaleProduct saleProduct) async {
    saleProduct.product.idStore = widget.user.cashboxes.first.id;
    log("print");
    showLoaderDialog(context);
    Data<String> result = await _productService.deleteProductInSale(saleProduct);
    if (context.mounted){
      closeLoaderDialog(context);
      if (result.data == null) {
        showMessageDialog(context: context, 
        title: "Error",
        message: result.message);
      } else {
        setState(() {
          _result.data!.remove(saleProduct);
        });
      }
    }
  }

  void _backFunctionHandler (didPop) {
    if(didPop) {
      return;
    }
    if (_recentProducts.isEmpty) {
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
      });
    } else {
      showConfirmationDialog(
        context: context, 
        title: "Salir sin guardar",
        message: "Tiene cambios realizados ¿Desea salir de todas formas?", 
        onConfirmation: () {
          Future.delayed(Duration.zero, () {
            Navigator.pop(context);
          });
        }
      );
    }
  }
  
}