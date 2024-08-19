import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/screens/registers/role/permission_tree_data.dart';
import 'package:hotel/screens/registers/widgets/checkbox_tree_widget.dart';

class RoleFormScreen extends StatefulWidget {
  const RoleFormScreen({
    super.key,
  });

  @override
  State<RoleFormScreen> createState() => _RoleFormScreenState();
}

class _RoleFormScreenState extends State<RoleFormScreen> {
  final TextEditingController roleName = TextEditingController();
  final GlobalKey<FormState> _rolesFormState = GlobalKey<FormState>();
  final ParentTreeData configurationData = ParentTreeData(
    title: "Configuración", 
    children: [
      ChildTreeData(
        title: "Usuario", 
        children: [
          ValueTreeData(data: "Crear usuario"),
          ValueTreeData(data: "Modificar usuario"),
          ValueTreeData(data: "Eliminar usuario"),
        ],
      ),
      ChildTreeData(
        title: "Rol", 
        children: [
          ValueTreeData(data: "Crear rol"),
          ValueTreeData(data: "Modificar rol"),
          ValueTreeData(data: "Eliminar rol"),
        ],
      ),
    ],
  );

  final ParentTreeData cuentaData = ParentTreeData(
    title: "Cuentas", 
    children: [
      ChildTreeData(
        title: "Configuración", 
        children: [
          ValueTreeData(data: "Crear cuenta"),
          ValueTreeData(data: "Modificar cuenta"),
          ValueTreeData(data: "Eliminar cuenta"),
        ],
      ),
      ChildTreeData(
        title: "Movimientos cuentas", 
        children: [
          ValueTreeData(data: "Crear Movimiento"),
          ValueTreeData(data: "Modificar Movimiento"),
          ValueTreeData(data: "Eliminar Movimiento"),
        ],
      ),
    ],
  );

  final ParentTreeData sellsData = ParentTreeData(
    title: "Ventas", 
    children: [
      ChildTreeData(
        title: "ventas", 
        children: [
          ValueTreeData(data: "Crear venta"),
          ValueTreeData(data: "Anular venta"),
          ValueTreeData(data: "Modificar venta"),
          ValueTreeData(data: "Cobrar venta"),
          ValueTreeData(data: "Confirmar venta"),
          ValueTreeData(data: "Editar Fecha venta"),
          ValueTreeData(data: "Agregar Nota venta"),
          ValueTreeData(data: "Entregar venta"),
          ValueTreeData(data: "Mostrar interno venta"),
          ValueTreeData(data: "Mostrar chofer venta"),
        ],
      ),
    ],
  );


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _rolesFormState,
        child: Column(
          children: [
            InfoLabel(
              label: "Nombre",
              child: TextFormBox(),
            ),
            const SizedBox(height: 30,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: CheckboxTreeWidget(treeData: configurationData),
                ),
                Flexible(
                  child: CheckboxTreeWidget(treeData: cuentaData),
                ),
                Flexible(
                  child: CheckboxTreeWidget(treeData: sellsData),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}