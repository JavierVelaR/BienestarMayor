import 'package:alarm/alarm.dart';
import 'package:bienestar_mayor/ui/screen_splash.dart';
import 'package:flutter/material.dart';
import 'package:bienestar_mayor/router.dart' as router;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      onGenerateRoute: router.Router.generateRoute,
      home: const ScreenSplash(),
    );
  }
}

