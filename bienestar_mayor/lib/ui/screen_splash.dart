import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:bienestar_mayor/database/dao/historial_dao.dart';
import 'package:bienestar_mayor/database/db_helper.dart';
import 'package:bienestar_mayor/model/historial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../router.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  static const DURATION_SPLASH = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

    Future.delayed(DURATION_SPLASH).then((value) async{
      final listAlarmsStopped = await _cancelAlarmsRinging();

      if (listAlarmsStopped.isNotEmpty) {
        listAlarmsStopped.forEach((alarm) async {
          if (!await _historialExists(alarm.id)) {
            _insertHistorial(alarm.id);
          }
        });

        Navigator.pushNamedAndRemoveUntil(
            context, ROUTE_ALARM_RINGING, (route) => false,
            arguments: listAlarmsStopped);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, ROUTE_PRINCIPAL, (route) => false);
      }
    });
  }

  /// Cancelar las alarmas que están sonando actualmente
  Future<List<AlarmSettings>> _cancelAlarmsRinging() async {
    List<AlarmSettings> alarmsStopped = [];

    final allAlarms = Alarm.getAlarms();

    for (AlarmSettings alarm in allAlarms) {
      bool isAlarmActive = await Alarm.isRinging(alarm.id);
      if (isAlarmActive) {
        alarmsStopped.add(alarm);
        await Alarm.stop(alarm.id);

        debugPrint(
            'Cancelled alarm ${alarm.notificationTitle} that was currently active.');
      }
    }

    Alarm.checkAlarm();

    return alarmsStopped;
  }

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
        id_recordatorio: idRecordatorioMap[0]["id_recordatorio"], tomado: 0));
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

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeith = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80,),
            SvgPicture.asset(Assets.imagesBienestarMayorLogo, width: mediaWidth, height: mediaHeith, fit: BoxFit.cover),
            const Text("BienestarMayor", style: TextStyle(fontSize: 46, fontFamily: 'georgia'),)
          ],
        )
      ),
    );
  }
}