import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/desktop/products/products_screen.dart';
import 'package:hotel/screens/desktop/registers/settings_screen.dart';
import 'package:hotel/screens/desktop/room/rooms_page_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
 
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
            body: const RoomsPageManager(),
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
