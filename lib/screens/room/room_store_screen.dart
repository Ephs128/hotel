import 'package:flutter/material.dart';
import 'package:hotel/data/models/product_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/screens/room/rooms_screen.dart';
import 'package:hotel/widgets/forms/header_form_widget.dart';
import 'package:hotel/widgets/tables/table_cells/header_table_cell.dart';
import 'package:hotel/widgets/tables/table_cells/normal_table_cell.dart';

class RoomStoreScreen extends StatefulWidget {

  final Function(Widget) changeScreenTo;
  final Room room;

  const RoomStoreScreen({
    super.key, 
    required this.changeScreenTo,
    required this.room,
  });

  @override
  State<RoomStoreScreen> createState() => _RoomStoreScreenState();
}

class _RoomStoreScreenState extends State<RoomStoreScreen> {
  
  late String title;
  final List<List<String>> productsInOrder = [
    ["Datos Hardcodeados", "1", "10"],
    ["Salchipapa", "1", "10"],
    ["Hamburguesa", "1", "10"],
    ["Refresco", "1", "8"],
    ["Gaseosa", "1", "10"],
    ["Vino", "1", "50"],
  ];
  final List<Product> productsAvilable = [
    Product(productName: "prod 1", description: "description", type: 1, price: 50),
    Product(productName: "prod 2", description: "description", type: 1, price: 10),
    Product(productName: "prod 3", description: "description", type: 1, price: 90),
    Product(productName: "prod 4", description: "description", type: 1, price: 550),
    Product(productName: "prod 5", description: "description", type: 1, price: 50),
    Product(productName: "prod 6", description: "description", type: 1, price: 520),
    Product(productName: "prod 7", description: "description", type: 1, price: 40),
    Product(productName: "prod 8", description: "description", type: 1, price: 50),
    Product(productName: "prod 9", description: "description", type: 1, price: 55),
    Product(productName: "prod 10", description: "description", type: 1, price: 10),
    Product(productName: "prod 11", description: "description", type: 1, price: 80),
    Product(productName: "prod 12", description: "description", type: 1, price: 30),
    Product(productName: "prod 13", description: "description", type: 1, price: 10),
  ];
  double total = 1000;

  @override
  void initState() {
    super.initState();
    title = "Pedido de la habitación ${widget.room.name}";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderFormWidget(
              back: () => backFunction(), 
              title: title,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(),
                        1: FixedColumnWidth(50),
                        2: FixedColumnWidth(50),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey[120]),
                          children: const [
                            HeaderTableCell(text: "Nombre"),
                            HeaderTableCell(text: "Cantidad"),
                            HeaderTableCell(text: "Precio"),
                          ]
                        ),
                        for (List<String> data in productsInOrder) 
                          TableRow(
                            decoration: BoxDecoration(color: Colors.grey[20]),
                            children: [
                              NormalTableCell(child: Text(data[0])), // todo: cambiar por los datos reales
                              NormalTableCell(child: Text(data[1])), // todo: cambiar por los datos reales
                              NormalTableCell(child: Text(data[2])), // todo: cambiar por los datos reales
                            ]
                          ),
                      ],
                    ),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(),
                        1: FixedColumnWidth(50),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.grey[20]),
                          children: [
                            const NormalTableCell(child: Text("Total:")),
                            NormalTableCell(child: Text(total.toString())),
                          ]
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Productos:"),
                    ListView(
                      children: productsAvilable.map((product) {
                        return ListTile(
                          title: Text(product.toString()),
                        );
                      }).toList()
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void backFunction() {
    widget.changeScreenTo(RoomsScreen(changeScreenTo: widget.changeScreenTo));
  }
}