
// import 'package:prueba_login/api/responses/response_login.dart';
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