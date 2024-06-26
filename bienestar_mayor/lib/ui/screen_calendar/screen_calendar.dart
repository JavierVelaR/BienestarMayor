import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:bienestar_mayor/control/manager_user.dart';
import 'package:bienestar_mayor/database/dao/evento_dao.dart';
import 'package:bienestar_mayor/database/db_helper.dart';
import 'package:bienestar_mayor/model/evento.dart';
import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:bienestar_mayor/ui/screen_calendar/panel_eventos.dart';
import 'package:bienestar_mayor/utils/string_utils.dart';
import 'package:bienestar_mayor/widgets/drawer_custom.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class ScreenCalendar extends StatefulWidget {
  const ScreenCalendar({super.key});

  @override
  State<ScreenCalendar> createState() => _ScreenCalendarState();
}

class _ScreenCalendarState extends State<ScreenCalendar> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var _calendarFormat = CalendarFormat.month;

  Map<DateTime, List<Evento>> _selectedEvents = {};

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<Evento> _listaEventosDia = List.empty();

  @override
  void initState() {
    super.initState();
    _cargarEventos();
    _cargarEventosDia();
  }

  List<Evento> _getEventsFromDay(DateTime date) {
    // Copiando la fecha argumentos, si que se cargan bien, sino no devuelve nada
    final fecha = DateTime(date.year, date.month, date.day);
    return _selectedEvents[fecha] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(),
      drawer: DrawerCustom(
        inicio: true,
        closeDrawer: () {
          scaffoldKey.currentState?.closeDrawer();
        },
      ),
      floatingActionButton: _floatingActionButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _calendar(),
            PanelEventos(_listaEventosDia, _borrarEvento),
          ],
        ),
      ),
    );
  }

  _appBar() => AppBar(
        title: const Text("Calendario",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: CustomColors.verdeBosque,
        toolbarHeight: 70,
        shadowColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
      );

  /// Boton para añadir evento y programar notificación
  _floatingActionButton() => FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(
          Icons.add,
          size: 34,
        ),
      );

  _addEvent() async {
    final tituloController = TextEditingController();
    final descripcionController = TextEditingController();
    final diaController = TextEditingController();
    diaController.text = _selectedDay.day.toString();
    final mesController = TextEditingController();
    mesController.text = _selectedDay.month.toString();

    final result = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Añadir evento"),
              titleTextStyle: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Título",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.zafiro)),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: tituloController,
                        decoration: const InputDecoration(
                          hintText: "Introduce el título",
                          hintStyle: TextStyle(fontSize: 18),
                          suffixIcon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      children: [
                        Text("Descripción",
                            style: TextStyle(
                                fontSize: 22,
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
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: descripcionController,
                        decoration: const InputDecoration(
                          hintText: "Descripción del evento",
                          hintStyle: TextStyle(fontSize: 18),
                          suffixIcon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("Día:",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: CustomColors.zafiro)),
                        SizedBox(
                          width: 40,
                          child: TextFormField(
                            controller: diaController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                            maxLength: 2,
                          ),
                        ),
                        const SizedBox(),
                        const Text("Mes:",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: CustomColors.zafiro)),
                        SizedBox(
                          width: 40,
                          child: TextFormField(
                            controller: mesController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                            maxLength: 2,
                          ),
                        ),
                      ],
                    ),
                    /////////////////////////////
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (tituloController.text.isNotEmpty &&
                        diaController.text.isNotEmpty &&
                        StringUtils.esNumero(diaController.text) &&
                        mesController.text.isNotEmpty &&
                        StringUtils.esNumero(mesController.text)) {
                      final dia = diaController.text;
                      final mes = mesController.text;
                      int anio = _selectedDay.year;

                      final event = Evento(
                          titulo: tituloController.text,
                          descripcion: descripcionController.text,
                          fecha:
                              "$anio-${int.parse(mes) < 10 ? '0$mes' : mes}-${int.parse(dia) < 10 ? '0$dia' : dia}");

                      // Insertar evento a la db
                      _saveEventAndScheduleNotification(
                          event, anio, int.parse(mes), int.parse(dia), true);

                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text(
                    "Aceptar",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ));
    if (result != null && result as bool && mounted) _cargarEventos();
  }

  _saveEventAndScheduleNotification(
      Evento event, int year, int month, int day, bool esEvento) {
    _insertEvento(event).then((newId) async {
      if (DateTime(year, month, day).isAfter(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.now().minute,
          DateTime.now().second))) {
        // Programar notificación
        // TODO: manejar que si es inicio de mes, se ponga el ultimo dia del mes anterior, y si es el 01/01, que se ponga el 31/12

        // Recoger audio del ManagerUser
        final path = await ManagerUser().getNotificationSound();
        final assetsPath = "assets/$path";

        // Configuración para que la alarma suene el mismo día a las 00:00, no se repita y se oculte
        Alarm.set(
            alarmSettings: AlarmSettings(
                id: newId,
                // dateTime: DateTime(year, month, day),

                // Para pruebas
                dateTime: DateTime(
                  year,
                  month,
                  DateTime.now().day,
                  DateTime.now().hour,
                  DateTime.now().minute,
                  DateTime.now().second + 10,
                ),
                assetAudioPath: assetsPath,
                notificationTitle: "${event.titulo} : ${event.fecha}",
                notificationBody: event.descripcion,
                loopAudio: false,
                volume: await ManagerUser().getAlarmVolume(),
                vibrate: true,
                androidFullScreenIntent: false));

        // Parar la alarma de evento
        Future.delayed(const Duration(seconds: 25)).then((value) {
          Alarm.stop(newId);
        });

        debugPrint("Alarma de evento: id: $newId, ${DateTime(
          year,
          month,
          DateTime.now().day,
          DateTime.now().hour,
          DateTime.now().minute,
          DateTime.now().second + 30,
        )}");
      }

      // Actualizar eventos del dia seleccionado
      _cargarEventosDia();
    });
  }

  /// Insertar evento en la db
  Future<int> _insertEvento(Evento event) async {
    final newId = await EventoDao().insertEvento(event);

    return newId;
  }

  _borrarEvento(Evento event) {
    EventoDao().deleteEvento(event).then((value) {
      // Actualizar eventos del dia seleccionado
      _cargarEventos();
      _cargarEventosDia();
    });

    // Borrar la alarma del evento
    Alarm.stop(event.id);
  }

  _calendar() {
    return TableCalendar(
      locale: "es_ES",
      focusedDay: _focusedDay,
      currentDay: DateTime.now(),
      firstDay: DateTime.utc(2024),
      lastDay: DateTime.utc(2028),
      startingDayOfWeek: StartingDayOfWeek.monday,
      eventLoader: _getEventsFromDay,

      headerStyle: const HeaderStyle(
          formatButtonTextStyle: TextStyle(
            fontSize: 18,
          ),
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 22),

          // Flechas para cambiar de rango de dias
          leftChevronIcon: Icon(
            Icons.chevron_left,
            size: 30,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            size: 30,
          )),

      // Formato mes, quincena, semana
      calendarFormat: _calendarFormat,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mes',
        CalendarFormat.twoWeeks: '2 Semanas',
        CalendarFormat.week: 'Semana'
      },

      // Dias de la semana (nombres)
      daysOfWeekHeight: 50,
      daysOfWeekStyle: const DaysOfWeekStyle(
          decoration: BoxDecoration(color: Colors.lightBlueAccent),
          weekdayStyle: TextStyle(fontSize: 20),
          weekendStyle: TextStyle(fontSize: 20, color: CustomColors.zafiro)),

      // Calendario
      calendarStyle: const CalendarStyle(
        // Filas
        rowDecoration: BoxDecoration(color: CustomColors.blancoFumee),

        //Numeros
        defaultTextStyle: TextStyle(fontSize: 20),
        weekendTextStyle: TextStyle(fontSize: 20, color: Colors.red),

        // Fiestas
        holidayTextStyle: TextStyle(fontSize: 20, color: Colors.blue),
        holidayDecoration: BoxDecoration(color: Colors.green),

        // Fuera del mes, por ahora invisibles
        outsideDaysVisible: false,
        outsideTextStyle: TextStyle(
            fontSize: 20, color: Colors.grey, fontStyle: FontStyle.italic),

        // Bordes
        tableBorder: TableBorder(
          horizontalInside: BorderSide(width: 1, color: Colors.grey),
          top: BorderSide(width: 2, color: Colors.grey),
          bottom: BorderSide(width: 3, color: Colors.grey),
        ),

        // Marcadores de eventos (como max 3, al clickar, abajo se verán todos)
        markerSize: 9,
        markersMaxCount: 3,
        markerMargin: EdgeInsets.symmetric(horizontal: 0.8),
      ),

      onFormatChanged: (CalendarFormat format) {
        setState(() {
          _calendarFormat = format;
        });
      },

      onDaySelected: (DateTime day, DateTime focusedDay) {
        setState(() {
          _selectedDay = day;
          _focusedDay = focusedDay;
          _cargarEventosDia();
        });
      },

      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
    );
  }

  //////////////////////////////// CARGAR DE DB //////////////////////////////
  _cargarEventos() async {
    final eventsMap = await DbHelper().db.query(EventoDao().tableName);
    List<Evento> events = eventsMap.map((e) => Evento.fromMap(e)).toList();

    // Reiniciar el mapa de eventos seleccionados
    _selectedEvents = {};

    // Iterar sobre todos los eventos y agregarlos al mapa según su fecha
    for (Evento event in events) {
      DateTime fechaEvento = DateTime(int.parse(event.fecha.substring(0,4)), int.parse(event.fecha.substring(5,7)), int.parse(event.fecha.substring(8)));
      if (_selectedEvents.containsKey(fechaEvento)) {
        // Si la fecha ya existe en el mapa, agregamos el evento a la lista existente
        _selectedEvents[fechaEvento]!.add(event);

      } else {
        // Si la fecha no existe en el mapa, creamos una nueva lista con el evento
        _selectedEvents[fechaEvento] = [event];
      }
    }

    // Actualizar el estado para que los cambios se reflejen en la interfaz
    setState(() {});
  }

  _cargarEventosDia() async {
    final fecha = _selectedDay;
    final anio = fecha.year;
    final mes = fecha.month;
    final dia = fecha.day;

    final eventsMap = await DbHelper().db.query(EventoDao().tableName,
        where: "fecha = ?", whereArgs: ["$anio-${mes < 10 ? '0$mes' : mes}-${dia < 10 ? '0$dia' : dia}"], orderBy: 'titulo ASC');
    List<Evento> events = eventsMap.map((e) => Evento.fromMap(e)).toList();
    debugPrint("CARGADOS EVENTOS DEL DIA: $dia de $mes");

    setState(() {
      _listaEventosDia = events;
    });
  }


}
