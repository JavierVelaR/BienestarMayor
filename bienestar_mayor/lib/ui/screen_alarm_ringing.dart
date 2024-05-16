import 'package:alarm/model/alarm_settings.dart';
import 'package:bienestar_mayor/database/dao/historial_dao.dart';
import 'package:bienestar_mayor/database/db_helper.dart';
import 'package:bienestar_mayor/model/historial.dart';
import 'package:bienestar_mayor/router.dart';
import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class ScreenAlarmRinging extends StatefulWidget {
  final List<AlarmSettings> alarms;

  const ScreenAlarmRinging(this.alarms, {super.key});

  @override
  State<ScreenAlarmRinging> createState() => _ScreenAlarmRingingState();
}

class _ScreenAlarmRingingState extends State<ScreenAlarmRinging> {
  bool _tomado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 5,
          ),
          widget.alarms.length == 1
              ? const Text(
                  "Ha sonado un recordatorio:",
                  style: TextStyle(fontSize: 30),
                )
              : Text("Han sonado ${widget.alarms.length} recordatorios:",
                  style: const TextStyle(
                    fontSize: 30,
                  )),
          const SizedBox(
            height: 20,
          ),
          _listAlarms(),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    for (var alarm in widget.alarms) {
                      _insertHistorial(alarm.id);
                    }

                    Navigator.pushNamedAndRemoveUntil(
                        context, ROUTE_PRINCIPAL, (route) => false);
                  },
                  child: Text(
                      "Me lo${widget.alarms.length > 1 ? "s" : ""} he tomado",
                      style: const TextStyle(
                        fontSize: 16,
                      ))),
              ElevatedButton(
                  onPressed: () {
                    // todo: postponer alarma, que salga un dialog pidiendo un numero, y si el dialog
                    // devuelve true, navigator.pop, sino, solo se cierra

                    Navigator.pushNamedAndRemoveUntil(
                        context, ROUTE_PRINCIPAL, (route) => false);
                  },
                  child: const Text("Más tarde",
                      style: TextStyle(
                        fontSize: 16,
                      ))),
            ],
          ),
        ],
      ),
    );
  }

  _appBar() => AppBar(
        title: const Text("BienestarMayor",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: CustomColors.berenjena,
        toolbarHeight: 70,
        shadowColor: Colors.black,
      );

  _listAlarms() => ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (_, __) => const SizedBox(
          height: 15,
        ),
        itemCount: widget.alarms.length,
        itemBuilder: (_, index) {
          final alarm = widget.alarms[index];
          return Column(
            children: [
              Text("${alarm.notificationTitle}",
                  style: const TextStyle(fontSize: 26)),
              Text(
                "${alarm.notificationBody}",
                style: const TextStyle(fontSize: 24),
              ),
            ],
          );
        },
      );

  _insertHistorial(int idRecordatorio) async {
    final List<Map<String, dynamic>> idRecordatorioMapList =
        await DbHelper().db.rawQuery(
      '''
    SELECT id
    FROM Recordatorios
    WHERE id = $idRecordatorio
  ''',
    );

    final idRecordatorioMap = idRecordatorioMapList.map((historialMap) {
      return {
        "id_recordatorio": historialMap['id_recordatorio'],
      };
    }).toList();

    HistorialDao().insertHistorial(Historial(
        id_recordatorio: idRecordatorioMap[0]["id_recordatorio"],
        tomado: _tomado));
  }
}
