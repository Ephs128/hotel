import 'package:flutter/material.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RoomCleaningProductView extends StatefulWidget {
  
  final Room room;

  const RoomCleaningProductView({
    super.key,
    required this.room,
  });

  @override
  State<RoomCleaningProductView> createState() => _RoomCleaningProductViewState();
}

class _RoomCleaningProductViewState extends State<RoomCleaningProductView> {
  bool _isLoading = false;
  bool _searching = false;
  late List<String> filteredList;
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> productsList = [
    "Jabon",
    "Shampoo",
    "Dulces",
    "producto 2",
    "producto 1",
    "producto 22",
    "producto 23",
    "producto 26",
    "producto 7",
    "producto 75",
    "producto 12",
    "producto 2",
    "producto s",
    "producto 87",
    "producto 19",
    "producto 64",
    "producto 64",
    "producto 64",
    "producto 64",
  ];

  @override
  void initState() {
    super.initState();
    filteredList = productsList;
  }

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
    });

    //Simulates waiting for an API call
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _searchController.text.isEmpty ? 
        filteredList = productsList
      :
        filteredList = productsList
            .where((element) => element
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    if (_searching ){
      list = filteredList.map((product) {
        return Row(
          children: [
            Text(product.toString()),
            const Spacer(),
            IconButton(onPressed: () {}, icon: Icon(MdiIcons.minusCircleOutline)),
            const Text("0"),
            IconButton(onPressed: () {}, icon: Icon(MdiIcons.plusCircleOutline)),
          ],
        );
      }).toList();
    } else {
      list.addAll(productsList.map((product) {
        return Row(
          children: [
            Text(product.toString()),
            const Spacer(),
            IconButton(onPressed: () {}, icon: Icon(MdiIcons.minusCircleOutline)),
            const Text("0"),
            IconButton(onPressed: () {}, icon: Icon(MdiIcons.plusCircleOutline)),
          ],
        );
      }).toList());
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
                filteredList = productsList;
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
          onPressed: () {
            Navigator.pop(context);
          },
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