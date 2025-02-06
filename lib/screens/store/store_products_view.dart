import 'package:flutter/material.dart';
import 'package:hotel/data/models/aux_product_model.dart';
import 'package:hotel/data/models/aux_sale_product_model.dart';
import 'package:hotel/data/models/category_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/service/product_service.dart';
import 'package:hotel/env.dart';
import 'package:hotel/screens/error_view.dart';
import 'package:hotel/screens/loading_view.dart';
import 'package:hotel/screens/widgets/dialogs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StoreProductsView extends StatefulWidget {

  final Env env;
  final Room room;
  final int  idStore;

  const StoreProductsView({
    super.key,
    required this.env,
    required this.room,
    required this.idStore,
  });

  @override
  State<StoreProductsView> createState() => _StoreProductsViewState();
}

class _StoreProductsViewState extends State<StoreProductsView> {

  bool _isLoaded = false;
  late Data<List<Category>> _result;
  late ProductService _productService;
  final Map<Category, Map<AuxProduct, int>> _allProducts = {};
  late Category _selectedCategory;
  int _totalCant = 0;

  @override
  void initState() {
    super.initState();
    _productService = ProductService(env: widget.env);
    _fetchData();
  }

  void _fetchData() async {
    _result = await _productService.getProductsAvailables();
    if (_result.data != null ) {
      bool first = true;
      for (Category category in _result.data!) {
        Map<AuxProduct, int> auxMap = {};
        for(AuxProduct product in category.products) {
          product.idStore = widget.idStore;
          auxMap[product] = 0;
        }
        _allProducts[category] = auxMap;
        if (first) {
          _selectedCategory = category;
          first = false;
        }
      }
    }
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didpop) => _backFunctionHandler(didpop),
        child:!_isLoaded ? 
          const LoadingView() 
        : _result.data == null ? 
          ErrorView(message: _result.message)
          : _main(),
        )
    );
  }

  Widget _main() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              const Text("Categoría:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
              const SizedBox(width: 10,),
              Expanded(
                child: _dropdownCategories()
              ),
            ],
          ),
        ),
        Expanded(child: _productList()),
        const SizedBox(height: 30,),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 71, 90, 128),
              foregroundColor: Colors.white,
            ),
            onPressed: _totalCant > 0 ? () => _onAccept() : null, 
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text("Agregar", style: TextStyle(fontSize: 24),),
            ),
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }

  Widget _productList() {
    if (_allProducts[_selectedCategory]!.isEmpty) {
      return const Center(child: Text("No hay productos"),);
    } else {
      return SingleChildScrollView(
        child: Column(
          children: _allProducts[_selectedCategory]!.keys.map((value) => 
            _createTile(value)).toList(),
          )
        );
    }
  }

  Widget _dropdownCategories() {
    return DropdownButtonFormField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      isExpanded: true,
      value: _selectedCategory,
      items: _allProducts.keys.map((value) => 
        DropdownMenuItem(
          value: value,
          child: Row(
            children: [
              Text(value.name),
              const SizedBox(width: 10,),
              if (value.selectedCount > 0) Icon(MdiIcons.circleMedium,color: const Color.fromRGBO(35, 42, 60, 1),)
            ],
          ),
        ),
      ).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value!;
        });
      },
    );
  }

  Widget _createTile(AuxProduct product) {
    int cant = _allProducts[_selectedCategory]![product]!;
    TextStyle? boldTextStyle;
    if(cant > 0) {
      boldTextStyle = const TextStyle(fontWeight: FontWeight.bold);
    }
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Center(child: Text(formatNumber(product.cantity)))
        ),
        Expanded(child: Text(product.productName.toString(), style: boldTextStyle,)),
        IconButton(onPressed: () => _decreaseCounter(product), icon: Icon(MdiIcons.minusCircleOutline)),
        Text(cant.toString(), style: boldTextStyle,),
        IconButton(onPressed: () => _increaseCounter(product), icon: Icon(MdiIcons.plusCircleOutline)),
      ],
    );
  }

  void _increaseCounter(AuxProduct product) {
    int cant = _allProducts[_selectedCategory]![product]!;
    // if (cant < product.cantity){
      _totalCant ++;
      _selectedCategory.selectedCount ++;
      cant ++;
      setState(() {
        _allProducts[_selectedCategory]![product] = cant;
      });
    // }
  }

  void _decreaseCounter(AuxProduct product) {
    int cant = _allProducts[_selectedCategory]![product]!;
    if (cant > 0){
      _totalCant --;
      _selectedCategory.selectedCount --;
      cant --;
      setState(() {
        _allProducts[_selectedCategory]![product] = cant;
      });
    }
  }

  String formatNumber(double value) {
  // chat gpt :v
  // Convierte el número a String con un decimal
  String formatted = value.toStringAsFixed(1);
  
  // Si el valor tiene decimales pero el segundo decimal es 0, elimina los decimales
  if (formatted.endsWith(".0")) {
    return formatted.substring(0, formatted.length - 2); // Elimina el ".0"
  }
  return formatted;
}

 void _onAccept() {
  List<AuxSaleProduct> selectedProducts = [];
  for(Category category in _allProducts.keys) {
    if (category.selectedCount > 0 ) {
      for (MapEntry<AuxProduct, int> entry in _allProducts[category]!.entries) {
        for (int i = 0; i < entry.value; i++) {
          selectedProducts.add(
            AuxSaleProduct(
              idSale: widget.room.product.idVenta!, 
              idProduct: entry.key.idProduct, 
              price: entry.key.price, 
              product: entry.key)
          );
        }
      }
    }
  }
  Navigator.pop(context, selectedProducts);
 }


  void _backFunctionHandler (didPop) {
    if(didPop) {
      return;
    }
    if (_totalCant == 0) {
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