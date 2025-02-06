import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hotel/data/models/cashbox_model.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/models/fee_model.dart';
import 'package:hotel/data/models/product_model.dart';
import 'package:hotel/data/models/product_promo_model.dart';
import 'package:hotel/data/models/promo_model.dart';
import 'package:hotel/data/models/room_model.dart';
import 'package:hotel/data/models/sale_model.dart';
import 'package:hotel/data/models/sale_product_model.dart';
import 'package:hotel/data/models/user_cashbox_model.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/data/service/cashbox_service.dart';
import 'package:hotel/data/service/pay_service.dart';
import 'package:hotel/data/service/sale_service.dart';
import 'package:hotel/env.dart';
import 'package:hotel/screens/error_view.dart';
import 'package:hotel/screens/loading_view.dart';
import 'package:hotel/screens/widgets/dialogs.dart';

class PayView extends StatefulWidget {

  final Env env;
  final Room room;
  final User user;

  const PayView({
    super.key,
    required this.env,
    required this.room,
    required this.user,
  });

  @override
  State<PayView> createState() => _PayViewState();
}

class _PayViewState extends State<PayView> {
  // Constants
  final double _defaultFontSize = 18;
  final double _labelFontSize = 20;
  final Color _accentColor = const Color.fromRGBO(211, 211, 211, 1);
  final Color _rowColors = const Color.fromRGBO(239, 242, 247, 1);
  
  late Data<List<Cashbox>> _result;
  late CashboxService _cashboxService;

  final Map<Product, List<double>> _productTableData = {};
  late Data<Sale> _resultSale;
  late SaleService _saleService;
  // final 
  bool _isLoaded = false;
  bool _showCompoundPayment = false;

  final GlobalKey<FormState> _paymentFormState = GlobalKey<FormState>();
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _qrController = TextEditingController();
  final TextEditingController _transferController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late double _totalAmount;
  double _productsAmount = 0;
  late double _roomTimeAmount;
  late String _roomTime;

  ProductPromo? _selectedPromo;
  double _amountSelectedPromo = 0;
  final Map<ProductPromo, double> _promoOptions = {};
  
  Cashbox? _selectedCashbox;
  final List<Cashbox> _availableCashboxes = [];

  int _selectedMethod = 0;
  final List<String> _payMethodOptions = ["Efectivo", "QR", "Transferencia", "Compuesto" ];

  @override
  void initState() {
    super.initState();
    _cashboxService = CashboxService(env: widget.env);
    _saleService = SaleService(env: widget.env);
    _fetchData();
    _qrController.text = "0";
    _transferController.text = "0";
  }

  @override
  void dispose() {
    _qrController.dispose();
    _cashController.dispose();
    _transferController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    _result = await _cashboxService.getAllCashboxes();
    _resultSale = await _saleService.getSale(widget.room.product.idVenta!);
    List<Cashbox> cashboxList = _result.data ?? [];
    Sale? sale = _resultSale.data;
    bool first  =true;
    for (UserCashbox userCashbox in widget.user.cashboxes) {
      int id = userCashbox.idCashbox;
      Cashbox? cashbox = findCashboxById(id, cashboxList);
      if (cashbox != null) {
        _availableCashboxes.add(cashbox);
        if (first) {
          _selectedCashbox = cashbox;
          first = false;
        }
      }
    }
    if (sale != null) {
      _getTableCells(sale);
    }
    for(List<double> values in _productTableData.values) {
      _productsAmount += values.last;
    }
    Duration elapsedTime = DateTime.now().difference(widget.room.product.time!);
    int elapsedMinutes = elapsedTime.inMinutes;
    _roomTime = "${elapsedTime.inHours}:${elapsedTime.inMinutes.remainder(60)}";
    elapsedMinutes -= widget.room.product.toleranceOff!;
    calculateRoomAmount(elapsedMinutes);
    calculatePromos(elapsedMinutes);
    calculateTotalAmount();
    setState(() {
      _isLoaded = true;
    });
  }

  void _getTableCells(Sale sale) {
    for (SaleProduct saleProduct in sale.products) {
      Product product = saleProduct.product;
      if (_productTableData.containsKey(product)) {
        List<double> data = _productTableData[product]!;
        data.first += 1;
        data.last += saleProduct.price;
      } else {
        _productTableData[product] = [1, saleProduct.price];
      }
    }
  }

  void calculateTotalAmount() {
    
    if (_selectedPromo == null){
      _amountSelectedPromo = _roomTimeAmount;
    } else {
      _amountSelectedPromo = _promoOptions[_selectedPromo]!;
    }
      _totalAmount = _amountSelectedPromo + _productsAmount;
      _cashController.text = _totalAmount.toString();
  }

  void calculatePromos(int elapsedMinutes) {
    for(ProductPromo productPromo in widget.room.product.promos ?? []) {
      int aux = elapsedMinutes;
      Promo promo = productPromo.promo;
      double amount = double.parse(promo.price);
      aux -= promo.time;
      amount += _calculateExtraTime(aux);
      _promoOptions[productPromo] = amount; 
    }
  }

  void calculateRoomAmount(int elapsedMinutes) {
    Fee fee = widget.room.product.fee!;
    _roomTimeAmount = double.parse(fee.amount);
    elapsedMinutes -= fee.time;
    _roomTimeAmount += _calculateExtraTime(elapsedMinutes);
  }

  double _calculateExtraTime(int time) {
    double cost = 0;
    Fee fee = widget.room.product.fee!;
    double amount = double.parse(fee.additionalMount);
    double amount1 = double.parse(fee.additionalMount1);
    while(time > fee.additionalTime1) {
      cost += amount1;
      time -= fee.additionalTime1;
    }
    if (time > fee.additionalTime) {
      cost += amount1;
    } else {
      cost += amount;
    }
    return cost;
  }

  String? _validateQrField(String val) {
    double? qrAmount = double.tryParse(val);
    if (qrAmount == null) {
      return "Error"; 
    } else {
      double? transferAmount = double.tryParse(_transferController.text);
      if (transferAmount != null) {
        double aux = _totalAmount - transferAmount - qrAmount;
        if (aux < 0) {
          return "Excedido";
        }
      }
    }
    return null;
  }

  String? _validateTransferField(String val) {
    double? transferAmount = double.tryParse(val);
    if (transferAmount == null) {
      return "Error";
    } else {
      double? qrAmount = double.tryParse(_qrController.text);
      if (qrAmount != null) {
        double aux = _totalAmount - transferAmount - qrAmount;
        if (aux < 0) {
          return "Excedido";
        }
      }
    }
    return null;
  }

  Cashbox? findCashboxById(int id, List<Cashbox> cashboxList) {
    Cashbox? aux;
    for(Cashbox cashbox in cashboxList) {
      if(cashbox.id == id) {
        aux = cashbox;
        break;
      }
    }
    return aux;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cobro venta"),
      ),
      body: !_isLoaded ? 
        const LoadingView() 
      : _result.data == null ? 
        ErrorView(message: _result.message)
        : _resultSale.data == null ?
          ErrorView(message: _resultSale.message)
          : main(),
    );
  }

  Widget main() {
    const double space = 20;
    return SingleChildScrollView(
      child: Form(
        key: _paymentFormState,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelOf("Habitación:", Text(widget.room.name)),
              const SizedBox(height: space,),
              labelOf("Promoción:", _promoDropdown()),
              const SizedBox(height: space,),
              labelOf(
                "Descripción:", 
                TextFormField(
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  controller: _descriptionController,
                )
              ),
              const SizedBox(height: space,),
              detailsTable(),
              _totalRow(),
              const SizedBox(height: space,),
              labelOf("Caja:", _cashboxDropdown()),
              const SizedBox(height: space,),
              labelOf("Método de pago:", _payMethodDropdown()),
              if (_showCompoundPayment) _compoundPaymentOptions(),
              const SizedBox(height: space,),
              _buttons(),
              const SizedBox(height: space,),
            ],
          ),
        ),
      ),
    );
  }


  Widget labelOf(String text, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: TextStyle(fontSize: _labelFontSize),),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: DefaultTextStyle(
            style: TextStyle(fontSize: _defaultFontSize, color: Colors.black), 
            child: child
          ),
        ),
      ]);
  }

  Widget _cashboxDropdown() {
    return DropdownButtonFormField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      isExpanded: true,
      value: _selectedCashbox,
      items: _availableCashboxes.map(
        (cashbox) => DropdownMenuItem(
          value: _selectedCashbox,
          child: Text(
            cashbox.name, 
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ) 
      ).toList(), 
      onChanged: (value) {
          setState(() {
            _selectedCashbox = value;
          });
        }
    );
  }

  Widget _payMethodDropdown() {
    int index = -1;
    return DropdownButtonFormField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      isExpanded: true,
      value: _selectedMethod,
      items: _payMethodOptions.map(
        (payMethod) {
          index++;
          return DropdownMenuItem(
            value: index,
            child: Text(payMethod),
          );
        },
      ).toList(), 
      onChanged: (value) {
        setState(() {
          _selectedMethod = value!;
          _showCompoundPayment = value == 3;
          
        });
      }
    );
  }

  Widget _promoDropdown() {
    List<DropdownMenuItem<ProductPromo>> items = [
      const DropdownMenuItem(
        value: null,
        child: Text("Sin promoción")
      )
    ];
    for (ProductPromo promo in widget.room.product.promos ?? []) {
      items.add(DropdownMenuItem(
            value: promo,
            child: Text(promo.promo.details)
          ));
    }
    return DropdownButtonFormField<ProductPromo>(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      isExpanded: true,
      value: _selectedPromo,
      items: items,
      onChanged: widget.room.product.promos == null || widget.room.product.promos!.isEmpty ? null : (ProductPromo? value) {
        setState(() {
          _selectedPromo = value;
          calculateTotalAmount();
        });
      },
    );
  }

  Widget _compoundPaymentOptions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueGrey,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(),
            1: FixedColumnWidth(70),
          },
          children: [
            TableRow(
              children: [
                _normalCell("Monto Efectivo"),
                _inputCell(_totalAmount, _cashController, null, null, false),
              ]
            ),
            TableRow(
              children: [
                _normalCell("Monto QR"),
                _inputCell(_totalAmount, _qrController, _transferController, _validateQrField, true),
              ]
            ),
            TableRow(
              children: [
                _normalCell("Monto transferencia"),
                _inputCell(_totalAmount, _transferController, _qrController, _validateTransferField,true),
              ]
            ),
          ],
        ),
      ),
    );
  }

  Widget detailsTable() {
    List<TableRow> items = [
      TableRow(
        decoration: BoxDecoration(color: _accentColor),
        children: [
          _boldCell("Producto"),
          _boldCell("Cant"),
          _boldCell("Precio"),
        ]
      ),
    ];
    for (Product product in _productTableData.keys) {
      items.add(
        TableRow(
          decoration: BoxDecoration(color: _rowColors),
          children: [
            _normalCell(product.productName),
            _normalCell(_productTableData[product]!.first.toString()),
            _normalCell(_productTableData[product]!.last.toString()),
          ]
        )
      );
    }
    items.add(
        TableRow(
          decoration: BoxDecoration(color: _rowColors),
          children: [
            _normalCell(widget.room.name),
            _normalCell(_roomTime),
            _normalCell(_amountSelectedPromo.toString()),
          ]
        )
      );
    return ExpansionTile(
      tilePadding: const EdgeInsets.only(left: 0),
      title: Text("Detalle:", style: TextStyle(fontSize: _labelFontSize),),
      // leading: Icon(MdiIcons.receiptText),
      children: [
        Table(
          border: const TableBorder(
            // right: BorderSide(width: 1),
            // left: BorderSide(width: 1),
            horizontalInside: BorderSide(width: 1, style:  BorderStyle.solid),
          ),
          columnWidths: const {
            0: FlexColumnWidth(),
            1: FixedColumnWidth(60),
            2: FixedColumnWidth(70),
          },
          children: items,
        ),
      ],
    );
  }

  Widget _totalRow() {
    return Table(
      border: const TableBorder(bottom: BorderSide(width: 1)),
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FixedColumnWidth(80),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: _accentColor),
          children: [
            _boldCell("Total:"),
            _boldCell(_totalAmount.toString()),
          ]
        )
      ],
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

  Widget _inputCell(double amount, TextEditingController controller, TextEditingController? otherController, String? Function(String)? validator, bool enabled) {
    return TableCell(
      child: TextFormField(
        validator: validator == null ? null : (value) {
          value ??= "0";
          if (value.isEmpty) {
            value = "0";
          }
          return validator(value);
        },
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0),
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          isDense: true,
        ),
        enabled: enabled,
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          log(value);
          if (value.isEmpty) {
            value = "0";
          }
          if (otherController != null) {
            double? other = double.tryParse(otherController.text);
            double? current = double.tryParse(value);
            if (current != null && other != null) {
              double result = amount - other - current;
              if (result < 0) {
                result = 0;
              }
              setState(() {
                _cashController.text = result.toString();
              });
            }
          }

        },
      ),
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _thereAreErrors()? null : () => _onAccept(context), 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(86, 109, 229, 1), 
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            child: Text("Cobrar", style: TextStyle(fontSize: _labelFontSize),)
          ),
        ),
        const SizedBox(width: 30,),
        Expanded(
          child: ElevatedButton(
            onPressed: (){Navigator.pop(context);}, 
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(204, 66, 66, 1), 
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            child: Text("Descartar", style: TextStyle(fontSize: _labelFontSize),)
          ),
        ),
      ],
    );
  }

  bool _thereAreErrors() {
    bool errors = false;
    if (_paymentFormState.currentState != null) {
      errors = !_paymentFormState.currentState!.validate();
    }
    return errors;
  }

  void _onAccept(BuildContext context) async {
    showConfirmationDialog(
      context: context, 
      title: "Realizar cobro",
      message: "Se va a cobrar Bs. $_totalAmount a \"${widget.room.name}\". ¿Continuar?", 
      onConfirmation: () {
        _fucntionCall(context);
      }
    );
  }

  void _fucntionCall(BuildContext context) async {
    Data<String> result = await _callApi(context);
    if (context.mounted){
      if (result.data != null) {
        Navigator.of(context).pop();
      } else {
        showMessageDialog(
          context: context,
          title: "Error",
          message: result.message
        );
      }
    }
  }

  Future<Data<String>> _callApi(BuildContext context) async {
    showLoaderDialog(context);
    if(_selectedMethod != 3) {
      _qrController.text = "0";
      _cashController.text = "0";
      _transferController.text = "0";
    }
    PayService payService = PayService(env: widget.env);
    Data<String> result = await payService.postPay(
      _roomTime, widget.room, _roomTimeAmount, _totalAmount, 
      widget.user, _selectedMethod+1, 
      double.parse(_cashController.text), 
      double.parse(_transferController.text), 
      double.parse(_qrController.text), 
      _descriptionController.text, _selectedCashbox!.id, _selectedPromo?.promo);
    if (context.mounted) closeLoaderDialog(context);
    return result;
  }


}