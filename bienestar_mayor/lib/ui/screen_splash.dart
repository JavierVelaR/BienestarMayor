import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';
import '../router.dart';

class ScreenSplash extends StatefulWidget {
  // final bool isAlarmRinging;
  // final List<AlarmSettings>? alarmsRinging;
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

      listAlarmsStopped.isNotEmpty
          ? Navigator.pushNamedAndRemoveUntil(
              context, ROUTE_ALARM_RINGING, (route) => false,
              arguments: listAlarmsStopped)
          : Navigator.pushNamedAndRemoveUntil(
              context, ROUTE_PRINCIPAL, (route) => false);
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