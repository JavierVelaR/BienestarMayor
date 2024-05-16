import 'package:alarm/alarm.dart';
import 'package:bienestar_mayor/database/db_helper.dart';
import 'package:bienestar_mayor/notifications/local_notification.dart';
import 'package:bienestar_mayor/router.dart' as router;
import 'package:bienestar_mayor/ui/screen_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // initializeDateFormatting("es_ES");
  DbHelper().init();

  LocalNotification.initApp();
  Alarm.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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

