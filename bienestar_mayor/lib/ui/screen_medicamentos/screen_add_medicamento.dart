import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:bienestar_mayor/control/manager_user.dart';
import 'package:bienestar_mayor/database/dao/medicamento_dao.dart';
import 'package:bienestar_mayor/database/dao/recordatorio_dao.dart';
import 'package:bienestar_mayor/model/medicamento.dart';
import 'package:bienestar_mayor/model/recordatorio.dart';
import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:bienestar_mayor/ui/screen_medicamentos/panel_hour_duration.dart';
import 'package:bienestar_mayor/ui/screen_medicamentos/panel_name_dose_med.dart';
import 'package:bienestar_mayor/ui/screen_medicamentos/panel_photo_save.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ScreenAddMedicamento extends StatefulWidget {
  const ScreenAddMedicamento({super.key});

  @override
  State<ScreenAddMedicamento> createState() => _ScreenAddMedicamentoState();
}

class _ScreenAddMedicamentoState extends State<ScreenAddMedicamento>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _dosisController = TextEditingController();
  String _tipoDosis = "";
  int _horasEntreToma = -1;
  TimeOfDay? _horaInicio;
  DateTimeRange _selectedDayRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7)));
  XFile? _pickedFile;
  String _pickedFilePath = "";
  bool _fotoCogida = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body:
          // SingleChildScrollView(
          Column(
        children: [
          TabBar(
            controller: _tabController,
            labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            // indicatorSize: TabBarIndicatorSize.tab,
            // isScrollable: hasPosition,
            labelStyle:
                const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            labelColor: CustomColors.azulFrancia,
            tabAlignment: TabAlignment.center,
            tabs: const [
              Tab(
                text: "Nombre y dosis",
                icon: Icon(Icons.edit_note),
                iconMargin: EdgeInsets.only(bottom: 5),
              ),
              Tab(
                text: "Horas y Duración",
                icon: Icon(Icons.watch_later_outlined),
                iconMargin: EdgeInsets.only(bottom: 5),
              ),
              Tab(
                text: "Guardar",
                icon: Icon(Icons.save),
                iconMargin: EdgeInsets.only(bottom: 5),
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PanelNameDoseMed(_nextTab, _editName, _editDosis),
                PanelHourDurationMed(
                    _previousTab,
                    _nextTab,
                    _radioButtonsFrequency,
                    _seleccionarHora,
                    _selectedDayRange,
                    _editDuration),
                PanelPhotoSaveMed(_previousTab, _addPhoto, _buttonSave),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Controla el tabBar para ir hacia atrás
  _previousTab() {
    _tabController.animateTo(_tabController.index - 1);
  }

  /// Controla el tabBar para ir hacia delante
  _nextTab() {
    _tabController.animateTo(_tabController.index + 1);
  }

  _appBar() {
    return AppBar(
      title: const Text(
        "Añadir medicamento",
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      backgroundColor: CustomColors.azulFrancia,
      toolbarHeight: 70,
      shadowColor: Colors.black,
      // leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white, size: 55,), onPressed: (){ _showMenu(); },),
    );
  }

  ////////////////////////////////// ELEMENTOS FORMULARIO ////////////////////////////////////////
  Widget _editName() => TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          hintText: "Introduce el nombre",
          hintStyle: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          suffixIcon: Icon(Icons.edit),
        ),
        style: const TextStyle(fontSize: 20),
        autocorrect: false,
        maxLength: 30,
      );

  Widget _editDosis() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: TextField(
              controller: _dosisController,
              decoration: const InputDecoration(
                filled: true,
                hintText: "Introducir",
                hintStyle: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: false, signed: true),
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          DropdownMenu(
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 'mg', label: 'miligramos'),
              DropdownMenuEntry(value: 'ml', label: 'mililitros'),
              // DropdownMenuEntry(value: 'Sin dosis especificada', label: 'Sin especificar'),
            ],
            onSelected: (value) {
              value != null ? _tipoDosis = value : _tipoDosis = "";
            },
          )
        ],
      );

  Widget _radioButtonsFrequency() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
                value: 4,
                groupValue: _horasEntreToma,
                onChanged: (value) {
                  _selectHora(value!);
                  setState(() {
                    _horasEntreToma = value;
                  });
                }),
            const Text(
              "4 h",
              style: TextStyle(fontSize: 17),
            ),
            Radio(
                value: 6,
                groupValue: _horasEntreToma,
                onChanged: (value) {
                  _selectHora(value!);
                  setState(() {
                    _horasEntreToma = value;
                  });
                }),
            const Text(
              "6 h",
              style: TextStyle(fontSize: 17),
            ),
            Radio(
                value: 8,
                groupValue: _horasEntreToma,
                onChanged: (value) {
                  _selectHora(value!);
                  setState(() {
                    _horasEntreToma = value;
                  });
                }),
            const Text(
              "8 h",
              style: TextStyle(fontSize: 17),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
                value: 12,
                groupValue: _horasEntreToma,
                onChanged: (value) {
                  _selectHora(value!);
                  setState(() {
                    _horasEntreToma = value;
                  });
                }),
            const Text(
              "12 h",
              style: TextStyle(fontSize: 17),
            ),
            Radio(
                value: 24,
                groupValue: _horasEntreToma,
                onChanged: (value) {
                  _selectHora(value!);
                  setState(() {
                    _horasEntreToma = value;
                  });
                }),
            const Text(
              "24 h",
              style: TextStyle(fontSize: 17),
            ),
          ],
        ),
      ],
    );
  }

  _selectHora(int hora) async {
    final horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      helpText:
          "Seleccionar hora de inicio, para establecer alarmas cada $hora horas.",
      barrierDismissible: false,
      confirmText: "Confirmar",
      cancelText: "Cancelar",
    );
    setState(() {
      _horaInicio = horaSeleccionada;
    });
  }

  Widget _seleccionarHora() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Hora de inicio:",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          width: 8,
        ),
        _horaInicio != null
            ? Text(
                "${_horaInicio!.hour < 10 ? "0${_horaInicio!.hour}" : _horaInicio!.hour}:"
                "${_horaInicio!.minute < 10 ? "0${_horaInicio!.minute}" : _horaInicio!.minute} ",
                style: const TextStyle(fontSize: 20),
              )
            : const Text("00:00"),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
            onPressed: () {
              _selectHora(_horasEntreToma);
            },
            child: const Text(
              "Seleccionar",
              style: TextStyle(fontSize: 15),
            )),
      ],
    );
  }

  Widget _editDuration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                _selectedDayRange = DateTimeRange(
                    start: DateTime.now(),
                    end: DateTime.now().add(const Duration(days: 7)));
              });
            },
            child: const Text("7 días"),
          ),
        ),
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                _selectedDayRange = DateTimeRange(
                    start: DateTime.now(),
                    end: DateTime.now().add(const Duration(days: 14)));
              });
            },
            child: const Text("14 días"),
          ),
        ),
        SizedBox(
          width: 130,
          child: ElevatedButton(
            onPressed: () async {
              var selectedRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                locale: const Locale('es', 'ES'),
              );
              setState(() {
                if (selectedRange != null) _selectedDayRange = selectedRange;
              });
            },
            child: const Text("  Indicar\nDuración"),
          ),
        ),
      ],
    );
  }

  Widget _addPhoto() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          "Añadir foto:",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        ElevatedButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: _fotoCogida
                      ? const Text(
                          "Ya has seleccionado una foto, ¿quieres cambiarla?")
                      : const Text(
                          "¿Quieres tomar una foto o cargarla de la galería?"),
                  alignment: Alignment.center,
                  shadowColor: Colors.black,
                  elevation: 10,
                  actionsAlignment: MainAxisAlignment.end,
                  actions: [
                    TextButton(
                        onPressed: () async {
                          _pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                          if (_pickedFile != null &&
                              _pickedFile!.path.isNotEmpty) {
                            _pickedFilePath = _pickedFile!.path;
                            setState(() {
                              _fotoCogida = true;
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Tomar foto")),
                    TextButton(
                        onPressed: () async {
                          _pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (_pickedFile != null &&
                              _pickedFile!.path.isNotEmpty) {
                            _pickedFilePath = _pickedFile!.path;
                            setState(() {
                              _fotoCogida = true;
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Cargar foto")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("No")),
                  ],
                ),
              );
            },
            child: _fotoCogida
                ? const Icon(
                    Icons.verified,
                    size: 30,
                    color: CustomColors.verdeLima,
                  )
                : const Text("Añadir foto", style: TextStyle(fontSize: 16))),
      ],
    );
  }

  Widget _buttonSave() => SizedBox(
        width: 150,
        height: 60,
        child: FilledButton(
            onPressed: () {
              if (_guardarMedicamento()) {
                Navigator.pop(context, true);
              } else {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          "Error al guardar",
                          style: TextStyle(fontSize: 28),
                        ),
                        contentPadding: const EdgeInsets.all(25),
                        content: const Text(
                          "Tienes que rellenar todos los campos",
                          style: TextStyle(fontSize: 18),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Vale",
                                style: TextStyle(fontSize: 20),
                              )),
                        ],
                      );
                    });
              }
            },
            child: const Text(
              "Guardar",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            )),
      );

  ///////////////// FUNCIONES AUXILIDARES ////////////////////
  /// CONVERSOR DE NUMEROS A PALABRA
  String _toDate(int day, int monthNumber) {
    Map<int, String> months = {
      1: "enero",
      2: "febrero",
      3: "marzo",
      4: "abril",
      5: "mayo",
      6: "junio",
      7: "julio",
      8: "agosto",
      9: "septiembre",
      10: "octubre",
      11: "noviembre",
      12: "diciembre"
    };

    String month = months[monthNumber] ?? "Mes inválido";
    return "$day de $month";
  }

  /// Dice los dias que tiene el mes
  int _daysInMonth(int month) {
    switch (month) {
      case 1: // enero
      case 3: // marzo
      case 5: // mayo
      case 7: // julio
      case 8: // agosto
      case 10: // octubre
      case 12: // diciembre
        return 31;
      case 4: // abril
      case 6: // junio
      case 9: // septiembre
      case 11: // noviembre
        return 30;
      case 2: // febrero
        int anio = DateTime.now().year;
        return ((anio % 4 == 0 && anio % 100 != 0) || (anio % 400 == 0))
            ? 29
            : 28;
      default:
        return -1; // Valor inválido para el mes
    }
  }

  /////////////////// GUARDAR EN BASE DE DATOS ////////////////////////

  /// Insertar medicamento a db, devuelve true si se ha insertado correctamente
  bool _guardarMedicamento() {
    String nombre = _nameController.text;
    String dosis = _dosisController.text;
    String tipoDosis = _tipoDosis;
    String dosisText = "$dosis $tipoDosis";
    int horasEntreToma = _horasEntreToma;
    TimeOfDay? horaInicio = _horaInicio;
    int duracion = _selectedDayRange.duration.inDays;

    if (nombre.isEmpty) {
      Fluttertoast.showToast(msg: "Tienes que añadir un nombre al medicamento");
      return false;
    } else if (dosis.isEmpty) {
      Fluttertoast.showToast(msg: "Tienes que añadir una cantidad de dosis");
      return false;
    } else if (tipoDosis.isEmpty) {
      Fluttertoast.showToast(msg: "Tienes que especificar el tipo de dosis");
      return false;
    } else if (horasEntreToma == -1) {
      Fluttertoast.showToast(msg: "Tienes que añadir el intervalo de horas");
      return false;
    } else if (horaInicio == null) {
      Fluttertoast.showToast(msg: "Tienes que fijar la hora de inicio");
      return false;
    }

    debugPrint(
        "Nombre: $nombre, dosis: $dosisText, horas entre cada toma: $horasEntreToma, hora de inicio de las tomas: $horaInicio, "
        "duración: $duracion días}");

    final newMedicamento = Medicamento(
        nombre: nombre,
        dosis: dosisText,
        frecuencia: horasEntreToma,
        duracion: duracion,
        foto: _pickedFilePath.isEmpty ? "" : _pickedFilePath);

    /// Insertar medicamento en db, crear los recordatorios e insertarlos en la db, y programar las alarmas
    _insertarEnDb(newMedicamento);

    return true;
  }

  /// Insertar medicamento en la db, creando los recordatorios a las horas que corresponden e insertándolos en la db,
  /// más crear alarmas y posponerlas hasta cada hora correspondiente
  _insertarEnDb(Medicamento med) async {
    final newId = await MedicamentoDao().insertMedicamento(med);
    med = med.copyWith(id: newId);

    TimeOfDay? horaInicio = _horaInicio;
    int duracion = _selectedDayRange.duration.inHours;
    int mesActual = _selectedDayRange.start.month;
    int diaActual = _selectedDayRange.start.day;

    // Función recursiva para programar los recordatorios
    void programarRecordatorios(
        int horasRestantes, int hora, int minutos, int dia, int mes) {
      if (horasRestantes <= 0) {
        return; // Condición de salida de la recursión
      }

      // Crear recordatorio e insertarlo en la base de datos
      final newRecordatorio = Recordatorio(
        id_medicamento: med.id,
        hora:
            "${_selectedDayRange.start.year}-$mes-${dia < 10 ? '0$dia' : dia} "
            "${hora < 10 ? '0$hora' : hora}:"
            "${minutos < 10 ? '0$minutos' : minutos}",
      );
      _insertarRecordatorioEnDbYprogramarAlarma(
          newRecordatorio, med, mes, dia, hora, minutos);
      debugPrint("----> Insertado recordatorio en db");

      // Calcular la próxima hora de recordatorio
      hora += _horasEntreToma;
      minutos += (_horasEntreToma * 60);

      // Ajustar las horas si exceden 24 horas en un día
      if (hora >= 24) {
        hora -= 24;
        dia++;
        if (dia > _daysInMonth(mes)) {
          mes++;
          dia = 1;
        }
      }
      // Ajustar los minutos si exceden 60 minutos en una hora
      minutos %= 60;

      // Llamar recursivamente a la función con las horas restantes y las nuevas variables
      programarRecordatorios(
          horasRestantes - _horasEntreToma, hora, minutos, dia, mes);
    }

    // Llamar a la función recursiva con las horas totales de duración y las variables iniciales
    programarRecordatorios(
        duracion, horaInicio!.hour, horaInicio.minute, diaActual, mesActual);
  }

  _insertarRecordatorioEnDbYprogramarAlarma(Recordatorio rec, Medicamento med,
      int mes, int dia, int hora, int minuto) async {
    final newId = await RecordatorioDao().insertRecordatorio(rec);
    rec = rec.copyWith(id: newId);

    _programarAlarma(newId, med, mes, dia, hora, minuto);
  }
  _programarAlarma(int idRecordatorio, Medicamento med, int mes, int dia,
      int hora, int minuto) async {
    // Recoger audio del ManagerUser
    final path = await ManagerUser().getAlarmSound();
    final assetsPath = "assets/$path";

    final alarmSettings = AlarmSettings(
        id: idRecordatorio,
        dateTime: DateTime(2024, mes, dia, hora, minuto),
        assetAudioPath: assetsPath,
        notificationTitle: 'Toma de ${med.nombre}',
        notificationBody: 'Tomar ${med.dosis} de ${med.nombre}',
        fadeDuration: 3.0,
        loopAudio: true,
        vibrate: true,
        volume: await ManagerUser().getAlarmVolume(),
        androidFullScreenIntent: true,
        enableNotificationOnKill: true);

    // Comprobar que la alarma que haya puesto no sea anterior a la fecha actual
    if (alarmSettings.dateTime.isAfter(DateTime.now())) {
      await Alarm.set(alarmSettings: alarmSettings);
      debugPrint(
          "Alarma programada: ${alarmSettings.notificationTitle}, ${alarmSettings.dateTime}");
    }
  }
}
