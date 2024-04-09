
import 'package:flutter/material.dart';
// import 'package:prueba_login/api/responses/response_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';


/// TODO: enlazar esta clase a base de datos
class ManagerUser {
  // Singleton ///////////////////////////////////////////////////////////////////////////////////////////////
  static final ManagerUser _instance = ManagerUser._internal();

  factory ManagerUser() {
    return _instance;
  }

  /// Constructor del singleton
  ManagerUser._internal();


  ///////////////// CONTROL DE SESION ///////////////////////////

  /// Respuesta de login
  // late ResponseLogin _responseLogin;

  /// Token de la sesion
  // String get tokenSession => _responseLogin.token;

  // DateTime get latestLogin => _responseLogin.latestLogin;


  /// Id de usuario
  int _userId = -1;

  /// Acceso al id de user
  int get userId => _userId;

  /// Preferencias
  static const PREFS_USER_EMAIL = "user_email";
  static const PREFS_USER_PASS = "user_pass";
  // static const PREFS_TOKEN_SESSION = "token_session";

  /// Guarda la sesion en preferencias
  saveSessionToPrefs(String email, String pass /*, ResponseLogin responseLogin*/) async{
    // _responseLogin = responseLogin;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(PREFS_USER_EMAIL, email.trim());
    await prefs.setString(PREFS_USER_PASS, pass.trim());
    // await prefs.setString(PREFS_TOKEN_SESSION, _responseLogin.token);


    // Map<String, dynamic> decodedToken = JwtDecoder.decode(_responseLogin.token);
    // _userId = decodedToken['idUser'];
  }

  /// Comprueba si hay sesión guardada en preferencias
  Future<bool> thereIsSessionSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(PREFS_USER_EMAIL) && prefs.containsKey(PREFS_USER_PASS);
  }

  Future<Map<String, String>> getSessionFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return{
      PREFS_USER_EMAIL: prefs.getString(PREFS_USER_EMAIL)!,
      PREFS_USER_PASS: prefs.getString(PREFS_USER_PASS)!,
      // PREFS_TOKEN_SESSION: prefs.getString(PREFS_TOKEN_SESSION)!

    };

  }


  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(PREFS_USER_EMAIL);
    await prefs.remove(PREFS_USER_PASS);
    // await prefs.remove(PREFS_TOKEN_SESSION);
  }

}