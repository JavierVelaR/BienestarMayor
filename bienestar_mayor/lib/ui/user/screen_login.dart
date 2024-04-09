import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../generated/assets.dart';
import '../../router.dart';
import '../../theme/custom_colors.dart';
import '../../utils/validation_utils.dart';


class ScreenLogin extends StatefulWidget {
  @override
  State<ScreenLogin> createState() => _ScreenLoginState();

  const ScreenLogin({super.key});
}

class _ScreenLoginState extends State<ScreenLogin> {
  // Estado del panel
  String _textError = ""; // Indica respuesta de error
  bool _showingProgress = false;
  String _progressText = "";

  // Formularios y campos
  final _formKey = GlobalKey<FormState>();
  bool _showingPass = false;
  String _fieldEmail = "";
  String _fieldPass = "";

  /// Controladores para rellenar los campos en login
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();

  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showingProgress,

      /// PanelprogressHUD
      progressIndicator: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(_progressText,
                  style: Theme.of(context).textTheme.titleLarge!,
                  textAlign: TextAlign.center)
            ],
          )),

      child: Scaffold(
        body: Stack(
          children: [
            Form(
                key: _formKey,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Bienvenido!",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 40),
                        _showEditEmail(),
                        const SizedBox(height: 40),
                        _showEditPassword(),
                        _showErrorLabel(),
                        const SizedBox(height: 40),
                        _buttonLogin(),
                        const SizedBox(height: 10),
                        _labelRegistro(),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  /////////////////////// CAMPOS ////////////////////////
  _showEditEmail() => Theme(
      data: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
              fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w300),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: CustomColors.verdeEsmeralda),
          ),
        ),
      ),
      child: TextFormField(
        controller: _controllerEmail,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        decoration: const InputDecoration(hintText: "Introduce email"),
        onSaved: (email) => _fieldEmail = email!,
        validator: _validateEmail,
        textInputAction: TextInputAction.next,
      ));

  _showEditPassword() => Theme(
      data: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(
                fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w300),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CustomColors.verdeEsmeralda),
            )),
      ),
      child: TextFormField(
        controller: _controllerPass,
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
            hintText: "Introduce contraseña",
            suffix: GestureDetector(
              onTap: _functionShowPass,
              child: SvgPicture.asset(
                _showingPass ? Assets.imagesEyeClosed : Assets.imagesEyeOpened,
                width: 25,
              ),
            )),
        onSaved: (password) => _fieldPass = password!,
        validator: _validatePassword,
        obscureText: !_showingPass,
        textInputAction: TextInputAction.none,
      ));

  _showErrorLabel() => Padding(
    padding: const EdgeInsets.only(top: 30),
    child: Visibility(
      visible: _textError.isNotEmpty,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 220,
              child: Text(
                _textError,
                style: const TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    ),
  );

// Funcion mostrar contraseña
  _functionShowPass() => setState(() => _showingPass = !_showingPass);

  _buttonLogin() => Center(
    child: SizedBox(
      height: 50,
      width: 150,
      child: FilledButton(
        onPressed: () => _actionLogin(),
        child: const Text("Iniciar sesión"),
      ),
    ),
  );

  _labelRegistro() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("¿No tienes cuenta?",
          style: TextStyle(fontSize: 12, color: CustomColors.gris)),
      const SizedBox(
        width: 8,
      ),
      InkWell(
        onTap: () => _actionRegister(),
        child: const Text(
          "Registrarse",
          style:
          TextStyle(fontSize: 12, color: CustomColors.verdeEsmeralda),
        ),
      )
    ],
  );

  ////////////////// ACCIONES /////////////////////
  _actionLogin() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      //Guardar datos
      _formKey.currentState!.save();
      // Modo progreso
      _setStateProgress("Iniciando sesión");

      _fieldEmail = _controllerEmail.text;
      _fieldPass = _controllerPass.text;

      //Descargar usuario
      _dbLogin();
    } else {
      _setStateError("");
    }
  }

  _actionRegister() async {
    final resultRegister = await Navigator.pushNamed(context, ROUTE_REGISTER);

    if (resultRegister != null) {
      final List<String> result = resultRegister as List<String>;

      setState(() {
        _fieldEmail = result[0];
        _fieldPass = result[1];
        _controllerEmail.text = _fieldEmail;
        _controllerPass.text = _fieldPass;
      });
    }
  }

  _dbLogin() {
    // UserApi.login(_fieldEmail, _fieldPass)
    //     .then((ResponseLogin responseLogin) async {
    //   debugPrint("----------------LOGIN> ${responseLogin.message}");
    //
    //   await ManagerUser()
    //       .saveSessionToPrefs(_fieldEmail, _fieldPass, responseLogin);
    //
    //   if (mounted) {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, ROUTE_PROJECTS, arguments: [InstallationType.consumption], (route) => false);
    //   }
    // }).catchError((error) {
    //   _setStateError(error == HTTP_Consts.ERROR_NO_CONECTION
    //       ? "Error de conexión"
    //       : error == HTTP_Consts.ERROR_BAD_REQUEST
    //       ? "Usuario no encontrado o contraseña incorrecta"
    //       : error == HTTP_Consts.ERROR_USER_NOT_VALIDATED
    //       ? "Usuario no validado, revisa tu correo"
    //       : "Ocurrió un error, intenta de nuevo");
    //
    //   debugPrint(
    //       "____________ ERROR AL PULSAR EL BOTON: $error ___________________________");
    // });
  }

////////////////// VALIDACIONES ////////////////////////

  String? _validateEmail(String? email) => ValidationUtils.validateEmail(
      email, "Email está en blanco", "Email incorrecto");

  String? _validatePassword(String? password) =>
      ValidationUtils.validateTextNotEmpty(
          password, "Contraseña está en blanco");

////////////// CAMBIOS DE ESTADO  //////////////////////

  _setStateProgress(String text) {
    setState(() {
      _showingProgress = true;
      _progressText = text;
      _textError = "";
    });
  }

  _setStateError(String error) {
    setState(() {
      _showingProgress = false;
      _textError = error;
    });
  }
}
