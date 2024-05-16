import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
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
  List<AlarmSettings> _alarmsRinging = [];

  // final List<AlarmSettings> _alarmsRinging = [
  //   AlarmSettings(
  //     id: 1,
  //     dateTime: DateTime(2024, 1, 12, 10, 45),
  //     assetAudioPath: Assets.audioOversimplified,
  //     notificationTitle: 'Toma de ibuprofeno',
  //     notificationBody: 'Tomar 500mg de ibuprofeno',
  //     fadeDuration: 3.0,
  //     loopAudio: true,
  //     vibrate: true,
  //     volume: 1,
  //     androidFullScreenIntent: true,
  //     enableNotificationOnKill: true
  //   ),
  // ];

  @override
  void initState() {
    super.initState();

    _cancelAlarmsRinging();

    Future.delayed(DURATION_SPLASH).then((value) async{
      _alarmsRinging.isNotEmpty
          ? Navigator.pushNamedAndRemoveUntil(
              context, ROUTE_ALARM_RINGING, (route) => false,
              arguments: _alarmsRinging)
          : Navigator.pushNamedAndRemoveUntil(
              context, ROUTE_PRINCIPAL, (route) => false);
    });
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

  /// Cancelar las alarmas que están sonando actualmente
  _cancelAlarmsRinging() async {
    final allAlarms = Alarm.getAlarms();

    for (AlarmSettings alarm in allAlarms) {
      bool isAlarmActive = await Alarm.isRinging(alarm.id);
      if (isAlarmActive) {
        setState(() {
          _alarmsRinging.add(alarm);
        });
        await Alarm.stop(alarm.id);

        debugPrint(
            'Cancelled alarm ${alarm.notificationTitle} that was currently active.');
      }
    }
  }
}