import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:hotel/data/models/data.dart';
import 'package:hotel/data/service/login_service.dart';
import 'package:hotel/screens/desktop/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormState = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String message = "";

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> sendPostRequest(BuildContext context) async {
    String user = _nameController.text;
    String password = _passwordController.text;
    
    final loginService = LoginService();
    Data<String> result = await loginService.postLogin(user, password);
    if (context.mounted) Navigator.pop(context);

    if (result.data == null) {
      setState(() {
        message = result.message;
      });
      if (context.mounted) showErrorDialog(context);
    } else {
      if (context.mounted) {
        Navigator.push(
          context,
          FluentPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  String? Function(String?) emptyValidator = (value) {
    if (value == null || value.isEmpty) {
      return "Campo obligatorio";
    }
    return null;
  };

  void showLoaderDialog(BuildContext context) {
    ContentDialog alert = ContentDialog(
      content: Row(
        children: [
          const ProgressRing(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Cargando..."),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showErrorDialog(BuildContext context) {
    ContentDialog alert = ContentDialog(
      title: const Text("Error"),
      content: Text(message),
      style: ContentDialogThemeData(
        barrierColor: Colors.red.lightest,
        actionsPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      ),
      actions: [
        FilledButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Container(
        color: FluentTheme.of(context).cardColor,
        child: Center(
          child: SizedBox(
            width: 300,
            child: Form(
              key: _loginFormState,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoLabel(
                    label: "Nombre usuario",
                    child: TextFormBox(
                      controller: _nameController,
                      validator: emptyValidator,
                    ),
                  ),
                  const SizedBox(height: 10),
                  InfoLabel(
                    label: "Contraseña",
                    child: PasswordFormBox(
                      controller: _passwordController,
                      validator: emptyValidator,
                    ),
                  ),
                  const SizedBox(height: 30),
                  FilledButton(
                    onPressed: () => {
                      if (_loginFormState.currentState!.validate())
                      {
                        showLoaderDialog(context),
                        sendPostRequest(context)
                      }
                    },
                    child: const Text("Iniciar sesión"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
