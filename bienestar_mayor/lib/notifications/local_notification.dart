import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  // static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static late AndroidNotificationChannel
      channel/*= const AndroidNotificationChannel("canal1", "prueba")*/;

  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidInitializationSettings initializationSettingsAndroid;
  static bool isFlutterLocalNotificationsInitialized = false;
  static bool permissions = false;
  static bool exactPermissions = false;

  // Inicializar Plugin de notificaciones
  static Future initApp() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    permissions = (await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission())!;

    exactPermissions = (await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission())!;

    initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/launcher_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveNotificationResponse);

    setupFlutterNotifications();
  }

  //////////////////////////// NOTIFICATION RESPONSE ///////////////////////////////
  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('NOTIFICACION RECIBIDA, notification payload: $payload');
    }
    if (notificationResponse.actionId == "action_done")
      debugPrint("LA HA TOMADO");
    if (notificationResponse.actionId == "action_schedule")
      debugPrint("TOMATELAAAAA");
  }

  static void onDidReceiveNotificationResponsee(NotificationResponse response) {
    // Manejar la lógica cuando se toca una acción de la notificación aquí
    if (response.actionId == 'action_done') {
      debugPrint('SE LA HA TOMADOOOOO');
    } else if (response.actionId == 'action_schedule') {
      debugPrint('En 5 minutos te notifico');
    }
  }

  /////////////////////////// FLUTTER NOTIFICATIONS ////////////////////////////////
  static Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Crear un canal de notificación
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    isFlutterLocalNotificationsInitialized = true;
  }

  /////////////////// DISPLAY NOTIFICATION ////////////////////////
  static displayNotification(bool isEvent) async {
    await flutterLocalNotificationsPlugin.show(0, 'Notificación de prueba',
        'Dejame en paz', _notificationDetails(isEvent),
        payload: 'item x');
  }

  ////////////////////// TimeZones //////////////////////
  static scheduleNotification(
      int id, int year, int month, int day, int hour, int minute,
      {required bool esEvento}) async {
    // Controlar el tiempo
    tz.initializeTimeZones();
    final String currentLocation = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentLocation));

    // Opciones y Detalles de notificación
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id', 'your channel name',
      channelDescription: 'your channel description',
      // icon: 'ic_launcher',
      // icon: 'launch_background',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',

      tag: "tag",
      subText: "subtext",

      fullScreenIntent: esEvento ? false : true,
    );
    NotificationDetails notificationDetails =
        // NotificationDetails(android: androidNotificationDetails);
        _notificationDetails(esEvento);

    // Nueva notificación programada
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      "zona1",
      "zona1 body",
      tz.TZDateTime.now(tz.getLocation(currentLocation))
          .add(Duration(seconds: 1)),
      // tz.TZDateTime(tz.getLocation(currentLocation), year, month, day, hour, minute),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint(
        "Notificacion programada: $month, $day, $hour:$minute........ ${tz.TZDateTime.now(tz.getLocation(currentLocation))}");
  }

  // Detalles de la notificación
  static _notificationDetails(bool isEvent) {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            // icono personalizado con color de fondo
            icon: "@mipmap/launcher_icon",
            color: CustomColors.azulFrancia,

            // Acciones debajo de la notificación
            actions: isEvent
                ? null
                : [
                    const AndroidNotificationAction(
                      "action_done",
                      "Sí, la he tomado",
                      titleColor: Colors.blue,
                      cancelNotification: false,
                    ),
                    const AndroidNotificationAction(
                      "action_schedule",
                      "Un momento",
                      titleColor: Colors.red,
                      cancelNotification: false,
                    ),
                  ],
            fullScreenIntent: isEvent ? false : true,
            visibility: NotificationVisibility.public,
            // sound: ,
            enableVibration: true,
            enableLights: true,
            playSound: true,

            // Importancia de la notificación
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    return notificationDetails;
  }
}
