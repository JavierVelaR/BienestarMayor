import 'package:alarm/alarm.dart';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 8,
          ),
          widget.alarms.length == 1
              ? const Text(
                  "Ha sonado un\nrecordatorio:",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                )
              : Text("Han sonado ${widget.alarms.length} recordatorios:",
                  style: const TextStyle(
                    fontSize: 35,
                  )),
          const SizedBox(
            height: 40,
          ),
          _listAlarms(),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pushNamedAndRemoveUntil(
                        context, ROUTE_PRINCIPAL, (route) => false);
                  },
                  child: const Text("No puedo",
                      style:
                          TextStyle(fontSize: 20, color: CustomColors.rojo))),
              ElevatedButton(
                  onPressed: () async {
                    _tomado = true;

                    for (var alarm in widget.alarms) {
                      if (await _historialExists(alarm.id)) {
                        _updateHistorial(alarm.id);
                      }
                    }

                    Navigator.pushNamedAndRemoveUntil(
                        context, ROUTE_PRINCIPAL, (route) => false);
                  },
                  child: Text(
                      "Me lo${widget.alarms.length > 1 ? "s" : ""} he tomado",
                      style: const TextStyle(
                        fontSize: 20,
                        color: CustomColors.verdeEsmeralda,
                      ))),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                // todo: postponer alarma, con el valor del ManagerUser ¿?
                for (var alarm in widget.alarms) {
                  Alarm.set(
                      alarmSettings: AlarmSettings(
                          id: alarm.id,
                          dateTime:
                              alarm.dateTime.add(const Duration(minutes: 5)),

                          // para pruebas
                          // dateTime: alarm.dateTime.add(const Duration(minutes: 2)),

                          assetAudioPath: alarm.assetAudioPath,
                          notificationTitle: alarm.notificationTitle,
                          notificationBody: alarm.notificationBody,
                          volume: alarm.volume,
                          vibrate: alarm.vibrate,
                          loopAudio: alarm.loopAudio,
                          fadeDuration: alarm.fadeDuration,
                          androidFullScreenIntent:
                              alarm.androidFullScreenIntent,
                          enableNotificationOnKill:
                              alarm.enableNotificationOnKill));
                }

                Navigator.pushNamedAndRemoveUntil(
                    context, ROUTE_PRINCIPAL, (route) => false);
              },
              child: const Text("Más tarde",
                  style:
                      TextStyle(fontSize: 20, color: CustomColors.azulFrancia)))
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
              Text(alarm.notificationTitle,
                  style: const TextStyle(fontSize: 26)),
              Text(
                alarm.notificationBody,
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
        "id_recordatorio": historialMap['id'],
      };
    }).toList();

    HistorialDao().insertHistorial(Historial(
        id_recordatorio: idRecordatorioMap[0]["id_recordatorio"],
        tomado: _tomado ? 1 : 0));
  }

  _updateHistorial(int idRecordatorio) async {
    final db = DbHelper().db;
    final query = await db.query(HistorialDao().tableName,
        where: 'id_recordatorio = ?', whereArgs: [idRecordatorio]);
    final historialList =
        query.map((historialMap) => Historial.fromMap(historialMap)).toList();

    for (final historial in historialList) {
      HistorialDao().updateHistorial(Historial(
          id: historial.id,
          id_recordatorio: idRecordatorio,
          tomado: _tomado ? 1 : 0));
    }
  }

  Future<bool> _historialExists(int idRecordatorio) async {
    final db = DbHelper().db;

    final query = await db.query(HistorialDao().tableName,
        where: 'id_recordatorio = ?', whereArgs: [idRecordatorio]);
    final historialList =
        query.map((historialMap) => Historial.fromMap(historialMap)).toList();

    // db.query(HistorialDao().tableName, where: 'id = ?', whereArgs: [idHistorial]).then((query){
    //   final historialList = query.map((historialMap) => Historial.fromMap(historialMap)).toList();
    //   if(historialList.isNotEmpty) return true;
    //       else return false;
    // });

    if (historialList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
