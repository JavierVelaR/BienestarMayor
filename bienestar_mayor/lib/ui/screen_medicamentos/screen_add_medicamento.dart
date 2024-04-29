import 'package:alarm/model/alarm_settings.dart';
import 'package:bienestar_mayor/database/dao/medicamento_dao.dart';
import 'package:bienestar_mayor/database/dao/recordatorio_dao.dart';
import 'package:bienestar_mayor/model/medicamento.dart';
import 'package:bienestar_mayor/model/recordatorio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/custom_colors.dart';

class ScreenAddMedicamento extends StatefulWidget {
  const ScreenAddMedicamento({super.key});

  @override
  State<ScreenAddMedicamento> createState() => _ScreenAddMedicamentoState();
}

class _ScreenAddMedicamentoState extends State<ScreenAddMedicamento> {
  final _nameController = TextEditingController();
  final _dosisController = TextEditingController();
  String _tipoDosis = "";
  int _horasEntreToma = -1;
  TimeOfDay? _horaInicio;
  DateTimeRange _selectedDayRange = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7)));
  XFile? _pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Nombre del medicamento:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
              _editName(),
              const Text("Cantidad de dosis:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
              const SizedBox(height: 8,),
              _editDosis(),
              const SizedBox(height: 20,),
              const Text("Cada cuantas horas:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
              _radioButtonsFrequency(),
              _seleccionarHora(),
              const SizedBox(height: 20,),
              const Text("Duración del tratamiento:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
              const SizedBox(height: 10,),
              Text("Inicio: ${_toDate(_selectedDayRange.start.day, _selectedDayRange.start.month)}     "
                  "Fin: ${_toDate(_selectedDayRange.end.day, _selectedDayRange.end.month)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CustomColors.zafiro),
              ),
              const SizedBox(height: 10,),
              _editDuration(),
              const SizedBox(height: 20,),
              _addPhoto(),
              const SizedBox(height: 20,),
              _buttons(),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: const Text(
        "Añadir medicamento",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      backgroundColor: CustomColors.azulFrancia,
      toolbarHeight: 70,
      shadowColor: Colors.black,
      // leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white, size: 55,), onPressed: (){ _showMenu(); },),
    );
  }

  ////////////////////////////////// ELEMENTOS FORMULARIO ////////////////////////////////////////
  _editName() => TextField(
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

  _editDosis() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width/3,
        child: TextField(
          controller: _dosisController,
          decoration: const InputDecoration(
            filled: true,
            hintText: "Introducir",
            hintStyle: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          ),
          keyboardType:  const TextInputType.numberWithOptions(decimal: false, signed: true),
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
        onSelected: (value){ value!=null ? _tipoDosis = value : _tipoDosis = ""; },
      )
    ],
  );

  _radioButtonsFrequency(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
            value: 4,
            groupValue: _horasEntreToma,
            onChanged: (value){
              _selectHora(value!);
              setState(() {
                _horasEntreToma = value;
              });
            }),
        const Text("4 h"),
        Radio(
            value: 6,
            groupValue: _horasEntreToma,
            onChanged: (value){
              _selectHora(value!);
              setState(() {
                _horasEntreToma = value;
              });
            }),
        const Text("6 h"),
        Radio(
            value: 8,
            groupValue: _horasEntreToma,
            onChanged: (value){
              _selectHora(value!);
              setState(() {
                _horasEntreToma = value;
              });
            }),
        const Text("8 h"),
        Radio(
            value: 12,
            groupValue: _horasEntreToma,
            onChanged: (value){
              _selectHora(value!);
              setState(() {
                _horasEntreToma = value;
              });
            }),
        const Text("12 h"),
        Radio(
            value: 24,
            groupValue: _horasEntreToma,
            onChanged: (value){
              _selectHora(value!);
              setState(() {
                _horasEntreToma = value;
              });
            }),
        const Text("24 h"),
      ],
    );
  }

  _selectHora(int hora) async{
    final horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      helpText: "Seleccionar hora de inicio, para establecer alarmas cada $hora horas.",
      barrierDismissible: false,
      confirmText: "Confirmar",
      cancelText: "Cancelar",
    );
    setState(() {
      _horaInicio = horaSeleccionada;
    });
  }

  _seleccionarHora(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Hora de inicio:", style: TextStyle(fontSize: 20),),
        const SizedBox(width: 10,),
        _horaInicio!=null
            ? Text("${_horaInicio!.hour}:${_horaInicio!.minute} ", style: const TextStyle(fontSize: 20),)
            : ElevatedButton(
            onPressed: (){
              _selectHora(_horasEntreToma);
            },
            child: const Text("Seleccionar", style: TextStyle(fontSize: 15),)
        ),
      ],
    );
  }

  _editDuration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () async{
              setState(() {
                _selectedDayRange = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7)));
              });
            },
            child: const Text("7 días"),),
        ),

        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () async{
              setState(() {
                _selectedDayRange = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 14)));
              });
            },
            child: const Text("14 días"),),
        ),

        SizedBox(
          width: 130,
          child: ElevatedButton(
            onPressed: () async{
              var selectedRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),

              );
              setState(() {
                if(selectedRange!=null) _selectedDayRange = selectedRange;
              });
            },

            child: const Text("  Indicar\nDuración"),),
        ),
      ],
    );
  }

  _addPhoto(){
    bool fotoCogida = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("Añadir foto:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
        ElevatedButton(
            onPressed: () async{
              // código para añadir foto

              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: fotoCogida ? const Text("Ya has seleccionado una foto, ¿quieres cambiarla?")
                    : const Text("¿Quieres tomar una foto o cargarla de la galería?"),
                    alignment: Alignment.center,
                    shadowColor: Colors.black,
                    elevation: 10,
                    actionsAlignment: MainAxisAlignment.end,
                    actions: [
                      /// TODO: arreglar toma y carga de imagenes
                      TextButton(
                          onPressed: () async{
                            _pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                            if(_pickedFile != null && _pickedFile!.path.isNotEmpty){
                              setState(() {
                                fotoCogida = true;
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Tomar foto")),
                      TextButton(
                          onPressed: () async{
                            _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                            if(_pickedFile != null && _pickedFile!.path.isNotEmpty){
                              setState(() {
                                fotoCogida = true;
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Cargar foto")),
                      TextButton(onPressed: (){ Navigator.pop(context); }, child: const Text("No")),
                    ],
                  ),
              );

            },
            child: fotoCogida ? const Icon(Icons.verified, size: 30, color: CustomColors.verdeLima,)
                : const Text("Añadir foto", style: TextStyle(fontSize: 16))),
      ],
    );
  }

  _buttons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 60,
          child: FilledButton(
              onPressed: (){ Navigator.of(context).pop(); },
              child: const Text("Cancelar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),)
          ),
        ),
        const SizedBox(width: 25,),
        SizedBox(
          width: 150,
          height: 60,
          child: FilledButton(
              onPressed: (){
                if(_guardarMedicamento()) {
                  Navigator.pop(context, true);
                }else{
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Error al guardar", style: TextStyle(fontSize: 28),),
                          contentPadding: const EdgeInsets.all(25),
                          content: const Text("Tienes que rellenar todos los campos", style: TextStyle(fontSize: 18),),
                          actions: [
                            TextButton(
                                onPressed: (){ Navigator.pop(context); }, 
                                child: const Text("Vale", style: TextStyle(fontSize: 20),)
                            ),
                          ],
                        );
                      }
                  );
                }
              },
              child: const Text("Guardar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),)
          ),
        ),
      ],
    );
  }


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
        return ((anio % 4 == 0 && anio % 100 != 0) || (anio % 400 == 0)) ? 29 : 28;
      default:
        return -1; // Valor inválido para el mes
    }
  }


  /////////////////// GUARDAR EN BASE DE DATOS ////////////////////////

  ///insertar medicamento a db, devuelve true si se ha insertado correctamente
  bool _guardarMedicamento() {
    String nombre = _nameController.text;
    String dosis = _dosisController.text;
    String tipoDosis = _tipoDosis;
    String dosisText = "$dosis $tipoDosis";
    int horasEntreToma = _horasEntreToma;
    TimeOfDay? horaInicio = _horaInicio;
    int duracion = _selectedDayRange.duration.inDays;

    if(nombre.isEmpty || dosis.isEmpty || tipoDosis.isEmpty || horasEntreToma == -1 || horaInicio == null){
      return false;
    }
    debugPrint("Nombre: $nombre, dosis: $dosisText, horas entre cada toma: $horasEntreToma, hora de inicio de las tomas: $horaInicio, "
        "duración: $duracion días}");

    final newMedicamento = Medicamento(nombre: nombre, dosis: dosisText, frecuencia: horasEntreToma, duracion: duracion);

    /// Insertar medicamento en db, crear los recordatorios e insertarlos en la db, y programar las alarmas
    _insertarEnDb(newMedicamento);

    return true;
  }

  // _insertarEnDb(Medicamento med) async{
  //   final newId = await MedicamentoDao().insertMedicamento(med);
  //   med = med.copyWith(id: newId);
  //
  //   int horasEntreToma = _horasEntreToma;
  //   TimeOfDay? horaInicio = _horaInicio;
  //   int duracion = _selectedDayRange.duration.inDays;
  //   int mesActual = _selectedDayRange.start.month;
  //   int diaActual = _selectedDayRange.start.day;
  //   final vecesAlDia = 24/horasEntreToma;
  //   TimeOfDay horaTomaActual = horaInicio!;
  //
  //   // Dia de la duracion del tratamiento
  //   for(int dia=0; dia<duracion; dia++){
  //     diaActual +=dia;
  //     // Si en algun momento de la duracion del tratamiento supera los dias del mes, salta al siguiente mes
  //     if(diaActual > _daysInMonth(mesActual)) {
  //       mesActual++;
  //       diaActual = 1;
  //     }
  //
  //     for(int toma=0; toma<vecesAlDia; toma++){
  //
  //       // TODO: arreglar que la horaTomaActual sobrepasa las 24h
  //       int horaCounter = horaTomaActual.hour;
  //
  //       // Asegúrate de que las horas no excedan las 24 horas en un día
  //       horaCounter += horasEntreToma * toma;
  //       if (horaCounter >= 24) {
  //         // Si excede las 24 horas, ajusta las horas y el día
  //         horaCounter %= 24;
  //         diaActual++;
  //         if (diaActual > _daysInMonth(mesActual)) {
  //           mesActual++;
  //           diaActual = 1;
  //         }
  //       }
  //
  //       horaTomaActual = TimeOfDay(hour: horaCounter, minute: horaTomaActual.minute);
  //
  //       // Crear recordatorio e insertarlo en la db
  //       final newRecordatorio = Recordatorio(id_medicamento: med.id,
  //           hora: "${_selectedDayRange.start.year}-$mesActual-${diaActual < 10 ? '0$diaActual' : diaActual} "
  //               "${horaCounter < 10 ? '0$horaCounter' : horaCounter}:"
  //               "${horaTomaActual.minute < 10 ? '0${horaTomaActual.minute}' : horaTomaActual.minute}");
  //       _insertarRecordatorioEnDb(newRecordatorio);
  //       debugPrint("----> Insertado recordatorio en db");
  //
  //       // Programar una alarma para ese recordatorio
  //       _programarAlarma(mesActual, diaActual, horaCounter, horaTomaActual.minute);
  //     }
  //   }
  //
  // }

  /// Segundo intento
  // _insertarEnDb(Medicamento med) async{
  //   final newId = await MedicamentoDao().insertMedicamento(med);
  //   med = med.copyWith(id: newId);
  //
  //   int horasEntreToma = _horasEntreToma;
  //   TimeOfDay? horaInicio = _horaInicio;
  //   int duracion = _selectedDayRange.duration.inHours;
  //   int mesActual = _selectedDayRange.start.month;
  //   int diaActual = _selectedDayRange.start.day;
  //   final vecesAlDia = 24/horasEntreToma;
  //   int numToma = 0;
  //
  //   // Hora de la duracion del tratamiento
  //   for(int hora=0; hora<duracion; hora += horasEntreToma){
  //     int horaCounter = horaInicio!.hour;
  //
  //     horaCounter += horasEntreToma * numToma;
  //     numToma++;
  //
  //     // Asegúrate de que las horas no excedan las 24 horas en un día
  //     if (horaCounter >= 24) {
  //       debugPrint("------> HoraCounter es mayor que 24h");
  //       // Si excede las 24 horas, ajusta las horas y el día
  //       horaCounter %= 24;
  //       diaActual++;
  //
  //       // Si en algun momento de la duracion del tratamiento supera los dias del mes, salta al siguiente mes
  //       if (diaActual > _daysInMonth(mesActual)) {
  //         debugPrint("------> DiaActual es mayor que los dias del mes actual");
  //         mesActual++;
  //         diaActual = 1;
  //       }
  //     }
  //
  //     // Crear recordatorio e insertarlo en la db
  //     final newRecordatorio = Recordatorio(id_medicamento: med.id,
  //         hora: "${_selectedDayRange.start.year}-$mesActual-${diaActual < 10 ? '0$diaActual' : diaActual} "
  //             "${horaCounter < 10 ? '0$horaCounter' : horaCounter}:"
  //             "${horaInicio.minute < 10 ? '0${horaInicio.minute}' : horaInicio.minute}");
  //     _insertarRecordatorioEnDb(newRecordatorio);
  //     debugPrint("----> Insertado recordatorio en db");
  //
  //     // Programar una alarma para ese recordatorio
  //     _programarAlarma(mesActual, diaActual, horaCounter, horaInicio.minute);
  //   }
  // }

  /// GPT
  // _insertarEnDb(Medicamento med) async {
  //   final newId = await MedicamentoDao().insertMedicamento(med);
  //   med = med.copyWith(id: newId);
  //
  //   int horasEntreToma = _horasEntreToma;
  //   TimeOfDay? horaInicio = _horaInicio;
  //   int duracion = _selectedDayRange.duration.inDays;
  //   int mesActual = _selectedDayRange.start.month;
  //   int diaActual = _selectedDayRange.start.day;
  //   final vecesAlDia = 24 ~/ horasEntreToma; // Usa división entera para obtener la cantidad de veces al día
  //   // TimeOfDay horaTomaActual = horaInicio!;
  //
  //   // Día de la duración del tratamiento
  //   for (int dia = 0; dia < duracion; dia++) {
  //     diaActual += dia;
  //     // Si en algún momento de la duración del tratamiento supera los días del mes, salta al siguiente mes
  //     if (diaActual > _daysInMonth(mesActual)) {
  //       mesActual++;
  //       diaActual = 1;
  //     }
  //
  //     // Mantener el día actual constante para todas las tomas dentro del mismo día
  //     int diaTomaActual = diaActual;
  //
  //     for (int toma = 0; toma < vecesAlDia; toma++) {
  //       int horaCounter = horaInicio!.hour;
  //       int minutoCounter = horaInicio.minute;
  //
  //       // Asegúrate de que las horas no excedan las 24 horas en un día
  //       horaCounter += horasEntreToma * toma;
  //       while (horaCounter >= 24) {
  //         // Si excede las 24 horas, ajusta las horas y el día
  //         horaCounter -= 24;
  //         if (diaTomaActual > _daysInMonth(mesActual)) {
  //           mesActual++;
  //           diaTomaActual = 1;
  //         }
  //       }
  //
  //       // Crear recordatorio e insertarlo en la db
  //       final newRecordatorio = Recordatorio(
  //         id_medicamento: med.id,
  //         hora: "${_selectedDayRange.start.year}-$mesActual-${diaTomaActual < 10 ? '0$diaTomaActual' : diaTomaActual} ${horaCounter < 10 ? '0$horaCounter' : horaCounter}:$minutoCounter",
  //       );
  //       _insertarRecordatorioEnDb(newRecordatorio);
  //       debugPrint("----> Insertado recordatorio en db");
  //
  //       // Programar una alarma para ese recordatorio
  //       _programarAlarma(mesActual, diaTomaActual, horaCounter, minutoCounter);
  //     }
  //   }
  // }

  /// GPT segundo intento
  _insertarEnDb(Medicamento med) async {
    final newId = await MedicamentoDao().insertMedicamento(med);
    med = med.copyWith(id: newId);

    TimeOfDay? horaInicio = _horaInicio;
    int duracion = _selectedDayRange.duration.inHours;
    int mesActual = _selectedDayRange.start.month;
    int diaActual = _selectedDayRange.start.day;

    // Función recursiva para programar los recordatorios
    void programarRecordatorios(int horasRestantes, int hora, int minutos, int dia, int mes) {
      if (horasRestantes <= 0) {
        return; // Condición de salida de la recursión
      }

      // Crear recordatorio e insertarlo en la base de datos
      final newRecordatorio = Recordatorio(
        id_medicamento: med.id,
        hora: "${_selectedDayRange.start.year}-$mes-${dia < 10 ? '0$dia' : dia} "
            "${hora < 10 ? '0$hora' : hora}:"
            "${minutos < 10 ? '0$minutos' : minutos}",
      );
      _insertarRecordatorioEnDb(newRecordatorio);
      debugPrint("----> Insertado recordatorio en db");

      // Programar una alarma para ese recordatorio
      _programarAlarma(mes, dia, hora, minutos);

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
      programarRecordatorios(horasRestantes - _horasEntreToma, hora, minutos, dia, mes);
    }

    // Llamar a la función recursiva con las horas totales de duración y las variables iniciales
    programarRecordatorios(duracion, horaInicio!.hour, horaInicio.minute, diaActual, mesActual);
  }

  _insertarRecordatorioEnDb(Recordatorio rec) async {
    final newId = await RecordatorioDao().insertRecordatorio(rec);
    rec = rec.copyWith(id: newId);
  }

  _programarAlarma(int mes, int dia, int hora, int minuto) async{
    final alarmSettings = AlarmSettings(
      id: 1,
      dateTime: DateTime(2024, mes, dia, hora, minuto),
      assetAudioPath: '../media/alarmaLluvia.mp3',
      notificationTitle: 'Alarma de prueba',
      notificationBody: 'Esta alarma es de prueba',
      fadeDuration: 3.0,
    );

    // TODO: descomentar cuando quiera programar alarmas
    // TODO: comprobar que la alarma que haya puesto no sea anterior a la fecha actual
    // await Alarm.set(alarmSettings: alarmSettings);
  }

}
