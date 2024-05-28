import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:bienestar_mayor/database/db_helper.dart';
import 'package:bienestar_mayor/notifications/local_notification.dart';
import 'package:bienestar_mayor/router.dart' as router;
import 'package:bienestar_mayor/ui/screen_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializeDateFormatting("es_ES");
  await DbHelper().init();

  await LocalNotification.initApp();
  await Alarm.init();

  runApp(const MyApp());
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

class MyApp extends StatelessWidget {
  // final bool isAlarmRinging;
  // final List<AlarmSettings>? alarmsRinging;

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BienestarMayor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', 'ES'),
      ],
      onGenerateRoute: router.Router.generateRoute,
      home: const ScreenSplash(),
    );
  }
}

