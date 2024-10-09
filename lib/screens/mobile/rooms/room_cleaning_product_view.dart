import 'package:flutter/material.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/product_cleanning_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/models/store_product_model.dart';
import 'package:hotel/data/service/product_service.dart';
import 'package:hotel/screens/mobile/error_view.dart';
import 'package:hotel/screens/mobile/loading_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RoomCleaningProductView extends StatefulWidget {
  
  final Room room;
  final int cleanningProductsId;
  final List<ProductCleanning> selectedProducts;

  const RoomCleaningProductView({
    super.key,
    required this.room,
    required this.cleanningProductsId,
    required this.selectedProducts,
  });

  @override
  State<RoomCleaningProductView> createState() => _RoomCleaningProductViewState();
}

class _RoomCleaningProductViewState extends State<RoomCleaningProductView> {
  bool _isLoading = false;
  bool _searching = false;
  late List<StoreProduct> filteredList;
  final TextEditingController _searchController = TextEditingController();
  final Map<StoreProduct, int> productsCounter = {};

  // api call
  List<StoreProduct> _productsList = [];
  bool _isLoaded = false;
  Data<List<StoreProduct>>? _result;
  final productService = ProductService();
  

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    _result = await productService.getAllProductsIn(1);
    List<StoreProduct> auxList = _result!.data ?? [];
    _productsList = auxList.where((product) => product.product.idCategory == widget.cleanningProductsId).toList();
    for (StoreProduct product in _productsList) {
      int cant = _findCantitySelectedProduct(product);
      productsCounter[product] = cant;
    }
    setState(() {
      _isLoaded = true;
    });
    filteredList = _productsList;
  }

  int _findCantitySelectedProduct(StoreProduct product) {
    int cant = 0;
    for(ProductCleanning selectedProduct in widget.selectedProducts) {
      if (selectedProduct.productId == product.idProduct) {
        cant = selectedProduct.cantity;
      }
    }
    return cant;
  }

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
    });

    //Simulates waiting for an API call
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _searchController.text.isEmpty ? 
        filteredList = _productsList
      :
        filteredList = _productsList
            .where((element) => element.product.productName
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    !_isLoaded ? 
        const LoadingView() : 
    _result!.data == null ?
      Scaffold(
        appBar: AppBar(title: const Text("Productos"),),
        body: ErrorView(message: _result!.message)
      )  
    : 
      _mainContent();

    
  }

  Widget _mainContent() {
    List<Widget> list = [];
    if (_searching ){
      list = filteredList.map(_createProductTile).toList();
    } else {
      list = _productsList.map(_createProductTile).toList();
      list.add(const SizedBox(height: 70,));
    }
    return Scaffold(
      appBar: AppBar(
        title: _searching ? 
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: "Buscar ..."),
            onChanged: (value) {
              _search();
            },
          )
        : const Text("Productos"),
        automaticallyImplyLeading: !_searching,
        actions: _searching ? 
        [
          IconButton(
            onPressed: () {
              _closeSearch();
            }, 
            icon: Icon(MdiIcons.close))
        ] :
        [
          IconButton(
            onPressed: () {
              setState(() {
                _searching = true;
                filteredList = _productsList;
              });
            },
            icon: Icon(MdiIcons.magnify),
          )
        ] 
      ),
      
      bottomSheet: _searching ? null : Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(10),
        color: Colors.grey,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30)
          ),
          child: const Text(
            "Agregar",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white
            ),
          ),
          onPressed: () => _addSelectedProducts(),
        ),
      ),
      body: PopScope(
        canPop: !_searching,
        onPopInvoked: (didPop) {
          if (_searching) {
            _closeSearch();
          }
        },
        child: _isLoading ? 
          const Center(
            child: CircularProgressIndicator(),
          )
        : _searching && filteredList.isEmpty ?
          const Center(
            child: Text("No hay resultados"),
          )
        : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: list,
            ),
          ),
        ),
      ),
    );
  }

  Widget _createProductTile(StoreProduct product) {
    int cant = productsCounter[product]!;
    TextStyle? boldTextStyle;
    if(cant > 0) {
      boldTextStyle = const TextStyle(fontWeight: FontWeight.bold);
    }
    return Row(
      children: [
        Text(product.product.productName.toString(), style: boldTextStyle,),
        const Spacer(),
        IconButton(onPressed: () => _decreaseCounter(product), icon: Icon(MdiIcons.minusCircleOutline)),
        Text(cant.toString(), style: boldTextStyle,),
        IconButton(onPressed: () => _increaseCounter(product), icon: Icon(MdiIcons.plusCircleOutline)),
      ],
    );
  }

  void _increaseCounter(StoreProduct product) {
    int cant = productsCounter[product]! + 1;
    setState(() {
      productsCounter[product] = cant;
    });
  }

  void _decreaseCounter(StoreProduct product) {
    int cant = productsCounter[product]!;
    if (cant > 0){
      cant --;
      setState(() {
        productsCounter[product] = cant;
      });
    }
  }

  void _addSelectedProducts() {
    setState(() {
    widget.selectedProducts.clear();
      for(StoreProduct product in _productsList) {
        int cant = productsCounter[product]!;
        if (cant > 0) {
          widget.selectedProducts.add(
            ProductCleanning(
              productId: product.idProduct, 
              productName: product.product.productName, 
              cantity: cant, 
            )
          );
        }
      } 
    });
    Navigator.pop(context, widget.selectedProducts);
  }

  void _closeSearch() {
    _searchController.text = "";
    setState(() {
      _searching = false;
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}