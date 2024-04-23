import 'package:alarm/utils/extensions.dart';
import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:bienestar_mayor/widgets/drawer_custom.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/evento.dart';

class ScreenCalendar extends StatefulWidget {
  const ScreenCalendar({super.key});

  @override
  State<ScreenCalendar> createState() => _ScreenCalendarState();
}

class _ScreenCalendarState extends State<ScreenCalendar> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var _calendarFormat = CalendarFormat.month;

  final Map<DateTime, List<Evento>> _selectedEvents = {
    DateTime(2024,04,30): [Evento(titulo: "nombre", descripcion: "Descripcion")],
  };

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  /// TODO: Nueva tabla evento en vez de recordatorio ¿?¿?
  List<Evento> _listaRecordatorios = List.empty();

  @override
  void initState() {
    super.initState();
    _cargarRecordatorios();
  }

  /// TODO: No se ven los marcadores de evento
  List<Evento> _getEvents(date){
    return _selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Calendario", style: TextStyle(fontSize: 26)),
        centerTitle: true,
        backgroundColor: CustomColors.verdeBosque,
        toolbarHeight: 70,
        shadowColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 40,),
          onPressed: (){ scaffoldKey.currentState?.openDrawer(); },),
      ),

      drawer: DrawerCustom(inicio: true, closeDrawer: () {scaffoldKey.currentState?.closeDrawer(); },),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, size: 34,),
        onPressed: (){
          /// TODO: añadir evento/recordatorio y programar notificación

        },
      ),

      body: Column(
        children: [
          _calendar(),
          _listaRecordatorios.isEmpty
              ?  const Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: [SizedBox(height: 50,),
                  Text("Añade eventos a este día para verlos aquí",
                    style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic, color: Colors.grey),)]),
              )
          : Column(
            children: [
              const Text("Eventos:", style: TextStyle(fontSize: 20),),
              _listEventTiles(),
            ],
          )
        ],
      ),
    );
  }

  /// TODO: cuando haya recordatorios, que los dias en los que hay recordatorios tengan alguna marca de ello,
  /// a ser posible con color especifico de la categoria (cita médica, tratamiento, ocio, personal)
  _calendar(){
    return TableCalendar(
      locale: "es_ES",
      focusedDay: _focusedDay,
      currentDay: DateTime.now(),
      firstDay: DateTime.utc(2024),
      lastDay: DateTime.utc(2028),
      startingDayOfWeek: StartingDayOfWeek.monday,
      eventLoader: _getEvents,

      headerStyle: const HeaderStyle(
        formatButtonTextStyle: TextStyle(fontSize: 18,),
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 22),

        // Flechas para cambiar de rango de dias
        leftChevronIcon: Icon(Icons.chevron_left, size: 30,),
        rightChevronIcon: Icon(Icons.chevron_right, size: 30,)
      ),

      // Formato mes, quincena, semana
      calendarFormat: _calendarFormat,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mes',
        CalendarFormat.twoWeeks: '2 Semanas',
        CalendarFormat.week: 'Semana' },

      // Dias de la semana (nombres)
      daysOfWeekHeight: 50,
      daysOfWeekStyle: const DaysOfWeekStyle(
          decoration: BoxDecoration(color: Colors.lightBlueAccent),
          weekdayStyle: TextStyle(fontSize: 20),
          weekendStyle: TextStyle(fontSize: 20, color: CustomColors.zafiro)
      ),

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
        outsideTextStyle: TextStyle(fontSize: 20, color: Colors.grey, fontStyle: FontStyle.italic),

        // Bordes
        tableBorder: TableBorder(
          horizontalInside: BorderSide(width: 1, color: Colors.grey),
          top: BorderSide(width: 2, color: Colors.grey),
          bottom: BorderSide(width: 3, color: Colors.grey),
        ),

        // Marcadores de eventos (como max 3, al clickar, abajo se verán todos)
        markerSize: 10,
        markersMaxCount: 3,

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
        });
      },

      selectedDayPredicate: (day) { return isSameDay(_selectedDay, day); },
    );
  }


  //////////////////////////////// EVENTOS ///////////////////////////////
  _listEventTiles(){

  }

  ///TODO: al clickar un tile, que salgan los detalles en AlertDialog
  _eventTile(){

  }

  //////////////////////////////// CARGAR DE DB //////////////////////////////
  _cargarRecordatorios(){

  }

}
