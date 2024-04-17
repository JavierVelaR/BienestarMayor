import 'package:bienestar_mayor/theme/custom_colors.dart';
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

      drawer: DrawerCustom( closeDrawer: () {scaffoldKey.currentState?.closeDrawer(); },),

      /// TODO: boton para añadir evento/recordatorio
      floatingActionButton: FloatingActionButton(onPressed: (){}),

      body: Column(
        children: [
          _calendar(),
          const Text("Eventos:", style: TextStyle(fontSize: 20),)
        ],
      ),
    );
  }

  _calendar(){
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime.utc(2024),
      lastDay: DateTime.utc(2028),

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

      ),

      onFormatChanged: (CalendarFormat format) {
        setState(() {
          _calendarFormat = format;
        });
      },

    );
  }

  _listEventTiles(){

  }

  _eventTile(){

  }

}
