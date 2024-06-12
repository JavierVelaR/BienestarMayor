import 'package:audioplayers/audioplayers.dart';
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

  final AudioPlayer _audioPlayer = AudioPlayer();

  String? _selectedAlarmTone;

  String? _selectedNotificationTone;

  final List<String> _alarmTones = [
    "audio/morning_joy.mp3",
    "audio/ringtone.mp3",
    "audio/oversimplified.mp3",
    "audio/chiptune.mp3"
  ];

  // todo: añadir más tonos de notificacion
  String? _selectedNotifTone;

  final List<String> _notificationTones = [
    'audio/ringtone_jungle.mp3',
    'audio/Arpeggio.mp3',
    'audio/Asteroid.mp3',
    'audio/Bell-Android.mp3',
    'audio/Charm-original.mp3',
    'audio/Childlike-Android.mp3',
    'audio/Circles.mp3',
    'audio/Old-Car-Horn-iPhone.mp3',
    'audio/Shooting_Star-Android.mp3',
    'audio/Twinkle-original.mp3',
  ];

  double _volumeValue = 10;

  void _playAudio(String audioPath) async {
    await _audioPlayer.setSource(AssetSource(audioPath));
    _audioPlayer.setVolume(await ManagerUser().getAlarmVolume());
    await _audioPlayer.resume();
  }

  void _confirmAlarmSelection() {
    if (_selectedAlarmTone != null)
      ManagerUser().setAlarmSound(_selectedAlarmTone!);
    Fluttertoast.showToast(
        msg:
            "Tono de alarma cambiado a: ${_selectedAlarmTone.toString().split('/').last.split('.').first}");
    _audioPlayer.stop();
  }

  void _confirmNotificationSelection() {
    if (_selectedNotificationTone != null)
      ManagerUser().setNotificationSound(_selectedNotificationTone!);
    Fluttertoast.showToast(
        msg:
            "Tono de alarma cambiado a: ${_selectedNotificationTone.toString().split('/').last.split('.').first}");
    _audioPlayer.stop();
  }

  @override
  void initState() {
    super.initState();
    _cargarInfo();
    _cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _userData(),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Cambiar tono de alarma:",
              style: TextStyle(fontSize: 20),
            ),
            _dropdownAlarmTones(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _selectedAlarmTone != null
                      ? () => _playAudio(_selectedAlarmTone!)
                      : null,
                  child: const Text('Reproducir'),
                ),
                ElevatedButton(
                  onPressed: _selectedAlarmTone != null
                      ? _confirmAlarmSelection
                      : null,
                  child: const Text('Confirmar'),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Cambiar tono de notificación:",
              style: TextStyle(fontSize: 20),
            ),
            _dropdownNotificationTones(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _selectedNotificationTone != null
                      ? () => _playAudio(_selectedNotificationTone!)
                      : null,
                  child: const Text('Reproducir'),
                ),
                ElevatedButton(
                  onPressed: _selectedNotificationTone != null
                      ? _confirmNotificationSelection
                      : null,
                  child: const Text('Confirmar'),
                ),
              ],
            ),

            const SizedBox(
              height: 30,
            ),
            const Text(
              "Volumen de los recordatorios:",
              style: TextStyle(fontSize: 20),
            ),
            Slider(
              min: 1,
              max: 10,
              divisions: 9,
              label: _volumeValue.toStringAsFixed(0),
              value: _volumeValue,
              onChanged: (newValue) async {
                _volumeValue = newValue;
                _audioPlayer.setVolume(await ManagerUser().getAlarmVolume());
                ManagerUser().setAlarmVolume(_volumeValue / 10);
                setState(() {});
              },
            ),

            // Todo: numero de minutos del posponer?

            // todo: numeros de familiares para llamar al pulsar emergencia FUTURO
          ],
        ),
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

  _dropdownAlarmTones() => DropdownButton<String>(
        value: _selectedAlarmTone,
        hint: const Text('Selecciona un tono'),
        items: _alarmTones.map((String tone) {
          return DropdownMenuItem<String>(
            value: tone,
            child: Text(tone
                .split('/')
                .last
                .split('.')
                .first), // Muestra solo el nombre del archivo
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedAlarmTone = newValue;
          });
        },
      );

  _dropdownNotificationTones() => DropdownButton<String>(
        value: _selectedNotificationTone,
        hint: const Text('Selecciona un tono'),
        items: _notificationTones.map((String tone) {
          return DropdownMenuItem<String>(
            value: tone,
            child: Text(tone
                .split('/')
                .last
                .split('.')
                .first), // Muestra solo el nombre del archivo
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedNotificationTone = newValue;
          });
        },
      );

///////////////////////////// ACCIONES /////////////////////////////////
  _onEditClick(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Editar usuario"),
            titleTextStyle: const TextStyle(
                fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
            content: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nombre",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.zafiro)),
                    _editUsername(),
                    const SizedBox(
                      height: 40,
                    ),
                    const Row(
                      children: [
                        Text("Email",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: CustomColors.zafiro)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "* Opcional",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        )
                      ],
                    ),
                    _editEmail(),
                    const SizedBox(
                      height: 15,
                    ),
                    _showErrorLabel(),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _guardar(context);
                              });
                            },
                            child: const Text("Guardar")),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cerrar")),
                      ],
                    )
                  ]),
            ),
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
      if (_username != null) _usernameController.text = _username!;
      if (_email != null) _emailController.text = _email!;
    });

  }

  _cargarInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // _selectedAlarmTone = prefs.getString(ManagerUser.ALARM_SOUND)!.substring(7);
    // _selectedNotificationTone = prefs.getString(ManagerUser.NOTIFICATION_SOUND)!.substring(7);
    _volumeValue = (prefs.getDouble(ManagerUser.ALARM_VOLUME) ?? 1) * 10;

    setState(() {});
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
