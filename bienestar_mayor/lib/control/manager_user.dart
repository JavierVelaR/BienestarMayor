
// import 'package:prueba_login/api/responses/response_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

/// enlazar esta clase a base de datos ¿?
class ManagerUser {
  // Singleton ///////////////////////////////////////////////////////////////////////////////////////////////
  static final ManagerUser _instance = ManagerUser._internal();

  factory ManagerUser() {
    return _instance;
  }

  /// Constructor del singleton
  ManagerUser._internal();


  ///////////////// CONTROL DE SESION ///////////////////////////

  /// Id de usuario
  int _userId = -1;

  /// Acceso al id de user
  int get userId => _userId;

  /// Preferencias
  static const PREFS_USERNAME = "username";
  static const PREFS_USER_EMAIL = "user_email";
  static const ALARM_SOUND = "alarm_sound";
  static const NOTIFICATION_SOUND = "notification_sound";
  static const ALARM_VOLUME = "alarm_volume";

  Future<String> getAlarmSound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(ALARM_SOUND) ?? "assets/audio/oversimplified.mp3";
  }

  setAlarmSound(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(ALARM_SOUND, path);
  }

  Future<String> getNotificationSound() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(NOTIFICATION_SOUND) ??
        "assets/audio/ringtone_jungle.mp3";
  }

  setNotificationSound(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(NOTIFICATION_SOUND, path);
  }

  Future<double> getAlarmVolume() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(ALARM_VOLUME) ?? 1;
  }

  setAlarmVolume(double value) async {
    double volume = value;
    if (value > 1) {
      volume = 1;
    } else if (value < 0) {
      volume = 0;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(ALARM_VOLUME, volume);
    debugPrint("volumen de alarma: $volume");
  }

  /// Guarda la sesion en preferencias
  saveSessionToPrefs(String username, String email) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PREFS_USERNAME, username.trim());
    await prefs.setString(PREFS_USER_EMAIL, email.trim());

  }

  /// Comprueba si hay sesión guardada en preferencias
  Future<bool> thereIsSessionSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(PREFS_USER_EMAIL) && prefs.containsKey(PREFS_USERNAME);
  }

  Future<Map<String, String>> getSessionFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return{
      PREFS_USERNAME: prefs.getString(PREFS_USERNAME)!,
      PREFS_USER_EMAIL: prefs.getString(PREFS_USER_EMAIL)!,
      // PREFS_TOKEN_SESSION: prefs.getString(PREFS_TOKEN_SESSION)!

    };

  }

}