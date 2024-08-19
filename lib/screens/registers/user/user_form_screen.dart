import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:hotel/data/models/user_model.dart';
import 'package:hotel/screens/registers/user/users_register_screen.dart';

class UserFormScreen extends StatefulWidget {
  final Function(Widget) changeScreenTo;
  final String title;
  final User? user;
  final bool readOnly;

  const UserFormScreen({
    super.key, 
    required this.changeScreenTo, 
    required this.title, 
    this.user,
    this.readOnly = false,
  });

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final GlobalKey<FormState> _userFormState = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController firstLastname = TextEditingController();
  final TextEditingController secondLastname = TextEditingController();
  final TextEditingController identityDocumentation = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController user = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController password = TextEditingController();

  final RegExp _emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',);

  // Validadores
  String? _emailValidator(value) {
    String? errorMsg;
    if (value == null || value.isEmpty) {
      errorMsg = 'Por favor, ingresa un correo electrónico';
    } else if (!_emailRegExp.hasMatch(value)) {
      errorMsg = 'Por favor, ingresa un correo electrónico válido';
    }
    return errorMsg;
  }

  String? _idValidator(value) {
    String? errorMsg;
    if (value == null || value.isEmpty) {
      errorMsg = 'Por favor, ingresa un cedula de identidad';
    } else {
      int length = errorMsg!.length;
      if (length < 7) {
        errorMsg = 'La cedula de identidad debe tener 7 digitos';
      } else if (length > 8) {
        errorMsg = 'La cedula de identidad debe tener 7 digitos';
      }
    }
    return errorMsg;
  }

  @override
  Widget build(BuildContext context) {
    void backFunction() => 
      widget.changeScreenTo(
        UsersRegisterScreen(changeScreenTo: widget.changeScreenTo)
      );
    if (widget.user != null ) {
      name.text = widget.user!.person.name;
      firstLastname.text = widget.user!.person.firstLastname;
      secondLastname.text = widget.user!.person.secondLastname ?? "";
      identityDocumentation.text = widget.user!.person.identityDocument;
      email.text = widget.user!.person.email;
      user.text = widget.user!.user;
      phone.text = widget.user!.person.phone;
      address.text = widget.user!.person.address;
      password.text = widget.user!.password;
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Title
          Container(
            color: FluentTheme.of(context).activeColor,
            padding: const EdgeInsets.all(10),
            child: Row(
              children:[
                IconButton(
                  icon: const Row(
                    children: [
                      Icon(FluentIcons.chrome_back),
                      SizedBox(width: 5,),
                      Text("Atrás"),
                    ],
                  ), 
                  onPressed: backFunction,
                ),
                const Spacer(),
                Text(widget.title),
                const Spacer(),
              ],
            ),
          ),
          // Form data
          Form(
            key: _userFormState,
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48),
                    child: Column(
                      children: [
                        InfoLabel(
                          label: "Nombre",
                          child: TextFormBox(
                            readOnly: widget.readOnly,
                            controller: name,
                            expands: false,
                          ),
                        ),
                        const SizedBox(height: 16,),
                        InfoLabel(
                          label: "Apellido Paterno",
                          child: TextFormBox(
                            readOnly: widget.readOnly,
                            controller: firstLastname,
                            expands: false,
                          ),
                        ),
                        const SizedBox(height: 16,),
                        InfoLabel(
                          label: "Apellido Materno",
                          child: TextFormBox(
                            readOnly: widget.readOnly,
                            controller: secondLastname,
                            // placeholder: 'Name',
                            expands: false,
                          ),
                        ),
                        const SizedBox(height: 16,),
                        InfoLabel(
                          label: "CI",
                          child: TextFormBox(
                            readOnly: widget.readOnly,
                            controller: identityDocumentation,
                            expands: false,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            validator: _idValidator,
                          ),
                        ),
                        const SizedBox(height: 16,),
                        InfoLabel(
                          label: "Correo Electrónico",
                          child: TextFormBox(
                            readOnly: widget.readOnly,
                            controller: email,
                            validator: _emailValidator,
                            expands: false,
                          ),
                        ),
                        const SizedBox(height: 16,),
                        InfoLabel(
                          label: "Usuario",
                          child: TextFormBox(
                            readOnly: widget.readOnly,
                            controller: user,
                            // placeholder: 'Name',
                            expands: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 48),
                    child: Column(
                      children: [
                        
                        InfoLabel(
                          label: "Teléfono",
                          child: TextFormBox(
                            readOnly: widget.readOnly,
                            controller: phone,
                            expands: false,
                          ),
                        ),
                        const SizedBox(height: 16,),
                        InfoLabel(
                          label: "Dirección",
                          child: TextFormBox(
                            readOnly: widget.readOnly,
                            controller: address,
                            // placeholder: 'Name',
                            expands: false,
                          ),
                        ),
                        const SizedBox(height: 16,),
                        if (widget.user == null)
                        InfoLabel(
                          label: "Contraseña",
                          child: PasswordFormBox(
                            controller: password,
                            // placeholder: 'Name',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Almacenes
          const Text("Parte almacenes"),
          // Botones 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FilledButton(
                child: const Text("Aceptar?"), 
                onPressed: () {}
              ),
              FilledButton(
                onPressed: backFunction,
                child: const Text("Cancelar"), 
              ),
            ],
          ),
        ],
      ),
    );
  }

}