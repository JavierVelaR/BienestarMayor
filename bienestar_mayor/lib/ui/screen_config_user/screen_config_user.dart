import 'package:bienestar_mayor/control/manager_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/assets.dart';
import '../../theme/custom_colors.dart';

class ScreenConfigUser extends StatefulWidget {
  const ScreenConfigUser({super.key});

  @override
  State<ScreenConfigUser> createState() => _ScreenConfigUserState();
}

class _ScreenConfigUserState extends State<ScreenConfigUser> {
  String? _username;
  String? _email;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  String _textError = "";

  List<bool> selectedOption = <bool>[true,false];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _userData(),
          const SizedBox(height: 30,),
          const Text("Repetir alarmas si no se apaga:", style: TextStyle(fontSize: 20),),
          _repetirAlarmas(),
          ///TODO: numeros de familiares para llamar al pulsar emergencia
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: const Text(
        "Configuración",
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      backgroundColor: CustomColors.verdeBosque,
      toolbarHeight: 70,
      shadowColor: Colors.black,
      // leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white, size: 55,), onPressed: (){ _showMenu(); },),
    );
  }

  /// Datos del usuario y botón de editar
  _userData() => Row(
        children: [
          SizedBox(
            width: 260,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.imagesEyeClosed,
                  width: 60,
                ),
                const SizedBox(
                  height: 20,
                  width: 20,
                ),
                _username!=null && _username!.isNotEmpty
                    ? Text(_username!, style: const TextStyle(fontSize: 22),)
                    : const Text("Introduce nombre"),

                _email!=null
                    ? Text(_email!, style: const TextStyle(fontSize: 20),)
                    : const Text("Introduce email"),

              ],
            ),
          ),

          // Boton editar
          SizedBox(
            width: 120,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
              ),
              onPressed: () {
                _onEditClick(context);
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.edit,
                    size: 16,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Editar',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  _repetirAlarmas(){
    return ToggleButtons(
          isSelected: selectedOption,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: Colors.blue[700],
          selectedColor: Colors.white,
          fillColor: Colors.blue[300],
          textStyle: const TextStyle(fontSize: 16),
          onPressed: (int index) {
            /// TODO: alternar variable booleana en SharedPreferences desde ManagerUser
            setState(() {
              for (int i = 0; i < selectedOption.length; i++) {
                selectedOption[i] = i == index;
              }
            });
          },
          children: const [
            Text("No"),
            Text("Sí"),
          ],
    );
  }

///////////////////////////// ACCIONES /////////////////////////////////
  _onEditClick(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Editar usuario"),
            titleTextStyle: const TextStyle(
                fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nombre", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: CustomColors.zafiro)),
                  _editUsername(),
                  const SizedBox(height: 40,),
                  const Row(
                    children: [
                      Text("Email", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: CustomColors.zafiro)),
                      SizedBox(width: 10,),
                      Text("* Opcional", style: TextStyle(fontSize: 16, color: Colors.red),)
                    ],
                  ),
                  _editEmail(),
                  const SizedBox(height: 15,),
                  _showErrorLabel(),
                  const SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _guardar(context);
                            });
                            }, child: const Text("Guardar")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.of(context).pop();
                            }, child: const Text("Cerrar")),
                    ],
                  )

                ]),
            elevation: 10,
            shadowColor: CustomColors.negro,
          );
        });
  }

  //////////////////// EVENTOS //////////////////////
  _guardar(BuildContext context) async{
    final username = _usernameController.text;
    final email = _emailController.text;

    // Nombre rellenado
    if(username.isNotEmpty && username.length > 2) {
      // Email rellenado
      if(email.isNotEmpty) {
        if (email.contains('@') && email.contains('.')) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(ManagerUser.PREFS_USERNAME, username.trim());
          await prefs.setString(ManagerUser.PREFS_USER_EMAIL, email.trim());

          _cargarDatos();

          //Salir del dialog
          Navigator.of(context).pop();

          setState(() {
            _textError = "";
          });
          // Email rellenado mal
        } else {
          setState(() {
            _textError = "Email inválido";
          });
        }
      }
      // Email no rellenado
      else{
        setState(() {
          _email = "";
          _textError = "";
        });

        //Salir del dialog
        Navigator.of(context).pop();
      }
      // Nombre vacio o mal
    }else{
      setState(() {
        _textError = "Nombre inválido";
        Fluttertoast.showToast(msg: _textError);
      });
    }
  }

  _cargarDatos() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString(ManagerUser.PREFS_USERNAME);
    _email = prefs.getString(ManagerUser.PREFS_USER_EMAIL);

    setState(() {
      _usernameController.text = _username!;
      _emailController.text = _email!;
    });

  }

/////////////////////// CAMPOS DEL DIALOG //////////////////////////
  _editUsername() => TextFormField(
        controller: _usernameController,
        decoration: const InputDecoration(
          hintText: "Introduce el nombre",
          hintStyle: TextStyle(fontSize: 18),
          suffixIcon: Icon(Icons.edit),
        ),
      );

  _editEmail() => TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          hintText: "Introduce el nombre",
          hintStyle: TextStyle(fontSize: 18),
          suffixIcon: Icon(Icons.edit),
        ),
      );

  /// Si nombre o email mal escritos, mensaje de error
  _showErrorLabel() => Padding(
    padding: const EdgeInsets.only(top: 10),
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


}
