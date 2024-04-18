import 'package:bienestar_mayor/ui/screen_calendar/screen_calendar.dart';
import 'package:bienestar_mayor/ui/screen_config_user/screen_config_user.dart';
import 'package:bienestar_mayor/ui/screen_medicamentos/screen_add_medicamento.dart';
import 'package:bienestar_mayor/ui/screen_medicamentos/screen_medicamento_details.dart';
import 'package:bienestar_mayor/ui/screen_medicamentos/screen_medicamentos.dart';
import 'package:bienestar_mayor/ui/screen_principal/screen_principal.dart';
import 'package:flutter/material.dart';

const ROUTE_BASE = '/';
const ROUTE_PRINCIPAL = '/principal';
const ROUTE_CONFIG_USER = '/configUser';
const ROUTE_MEDICAMENTOS = '/medicamentos';
const ROUTE_ADD_MEDICAMENTO = '/add_medicamentos';
const ROUTE_MEDICAMENTO_DETAILS = '/medicamentos_details';
const ROUTE_CALENDAR = '/calendar';
const ROUTE_SEGUIMIENTO = '/seguimiento';
const ROUTE_EMERGENCY = '/emergency';

class Router{
  static Route<dynamic>? generateRoute(RouteSettings settings){
    switch(settings.name) {
      case ROUTE_PRINCIPAL:
        return MaterialPageRoute(
            builder: (_) => const ScreenPrincipal(), settings: settings);
      case ROUTE_CONFIG_USER:
        return MaterialPageRoute(
            builder: (_) => const ScreenConfigUser(), settings: settings);
      case ROUTE_MEDICAMENTOS:
        return MaterialPageRoute(
            builder: (_) => const ScreenMedicamentos(), settings: settings);
      case ROUTE_ADD_MEDICAMENTO:
        return MaterialPageRoute(
            builder: (_) => const ScreenAddMedicamento(), settings: settings);
      case ROUTE_MEDICAMENTO_DETAILS:
        return MaterialPageRoute(
            builder: (_) => const ScreenMedicamentoDetails(), settings: settings);
      case ROUTE_CALENDAR:
        return MaterialPageRoute(
            builder: (_) => const ScreenCalendar(), settings: settings);
      case ROUTE_SEGUIMIENTO:
        return MaterialPageRoute(
          ///Cambiar a ScreenSeguimiento
            builder: (_) => const ScreenCalendar(), settings: settings);
      case ROUTE_EMERGENCY:
        return MaterialPageRoute(
          ///Cambiar a ScreenEmergency
            builder: (_) => const ScreenCalendar(), settings: settings);
    }
    return null;
  }

}