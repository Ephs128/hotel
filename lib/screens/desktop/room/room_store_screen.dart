import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/product_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/screens/desktop/room/rooms_screen.dart';
import 'package:hotel/screens/desktop/widgets/forms/header_form_widget.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/header_table_cell.dart';
import 'package:hotel/screens/desktop/widgets/tables/table_cells/normal_table_cell.dart';

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
    
  ];
  double total = 1000;

  @override
  void initState() {
    super.initState();
    title = "Pedido de la habitación ${widget.room.name}";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HeaderFormWidget(back: () => backFunction(), title: title),
          const SizedBox(height: 20,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FlexColumnWidth(),
                          1: FixedColumnWidth(60),
                          2: FixedColumnWidth(60),
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
                        1: FixedColumnWidth(60),
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
              ),
              const SizedBox(width: 30,),
              Container(
                decoration: BoxDecoration(border: Border.all()),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height - 200,
                  width: MediaQuery.sizeOf(context).width / 4,
                  child: ListView(
                    shrinkWrap: true,
                    children: productsAvilable.map((product) {
                      return ListTile(
                        title: Text(product.toString()),
                      );
                    }).toList()
                  ),
                ),
              ),
          
            ],
          ),
          const SizedBox(height: 30,),
          FilledButton(
            child: const Text("Guardar"), 
            onPressed: () {}
          )
        ],
      ),
    );
  }

  void backFunction() {
    widget.changeScreenTo(RoomsScreen(changeScreenTo: widget.changeScreenTo));
  }
}