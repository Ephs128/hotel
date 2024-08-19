import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/stream_socket.dart';
import 'package:hotel/screens/products/products_screen.dart';
import 'package:hotel/screens/registers/settings_screen.dart';
import 'package:hotel/screens/room/rooms_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final StreamSocket _streamSocket = StreamSocket();
  
  @override
  void initState() {
    super.initState();
    _streamSocket.connectAndListen();
  }

  @override
  void dispose() {
    _streamSocket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        header: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: DefaultTextStyle(
            style: FluentTheme.of(context).typography.title!,
            child: const Text("Company Name"),
          ),
        ),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home_solid),
            title: const Text("Habitaciones"),
            body: const RoomsScreen(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.shop),
            title: const Text("Productos"),
            body: const ProductsScreen(),
          ),
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text("Configuración"),
            body: const SettingsScreen(),
          ),
        ],
        selected: _currentIndex,
        displayMode: PaneDisplayMode.open,
        onChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
