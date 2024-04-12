import 'package:bienestar_mayor/ui/screen_calendar/screen_calendar.dart';
import 'package:bienestar_mayor/ui/screen_principal/screen_principal.dart';
import 'package:flutter/material.dart';
import 'package:bienestar_mayor/ui/user/screen_login.dart';
import 'package:bienestar_mayor/ui/user/screen_register.dart';

const ROUTE_BASE = '/';
const ROUTE_LOGIN = '/login';
const ROUTE_REGISTER = '/register';
const ROUTE_PRINCIPAL = '/principal';
const ROUTE_MEDICAMENTOS = '/medicamentos';
const ROUTE_CALENDAR = '/calendar';
const ROUTE_SEGUIMIENTO = '/seguimiento';
const ROUTE_EMERGENCY = '/emergency';

class Router{
  static Route<dynamic>? generateRoute(RouteSettings settings){
    switch(settings.name) {
      case ROUTE_PRINCIPAL:
        return MaterialPageRoute(
            builder: (_) => const ScreenPrincipal(), settings: settings);
      case ROUTE_LOGIN:
        return MaterialPageRoute(
            builder: (_) => const ScreenLogin(), settings: settings);
      case ROUTE_REGISTER:
        return MaterialPageRoute(
            builder: (_) => const ScreenRegister(), settings: settings);
      case ROUTE_MEDICAMENTOS:
        return MaterialPageRoute(//Cambiar a ScreenMedicamentos
            builder: (_) => const ScreenCalendar(), settings: settings);
      case ROUTE_CALENDAR:
        return MaterialPageRoute(
            builder: (_) => const ScreenCalendar(), settings: settings);
      case ROUTE_SEGUIMIENTO:
        return MaterialPageRoute(//Cambiar a ScreenSeguimiento
            builder: (_) => const ScreenCalendar(), settings: settings);
      case ROUTE_EMERGENCY:
        return MaterialPageRoute(//Cambiar a ScreenEmergency
            builder: (_) => const ScreenCalendar(), settings: settings);
    }
    return null;
  }

}