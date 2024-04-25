class StringUtils{

  /// Dice los dias que tiene el mes
  int daysInMonth(int month) {
    switch (month) {
      case 1: // enero
      case 3: // marzo
      case 5: // mayo
      case 7: // julio
      case 8: // agosto
      case 10: // octubre
      case 12: // diciembre
        return 31;
      case 4: // abril
      case 6: // junio
      case 9: // septiembre
      case 11: // noviembre
        return 30;
      case 2: // febrero
        int anio = DateTime.now().year;
        return ((anio % 4 == 0 && anio % 100 != 0) || (anio % 400 == 0)) ? 29 : 28;
      default:
        return -1; // Valor inválido para el mes
    }
  }

  /// CONVERSOR DE NUMEROS A PALABRA
  static String toDateDayMonth(int day, int monthNumber) {
    Map<int, String> months = {
      1: "enero",
      2: "febrero",
      3: "marzo",
      4: "abril",
      5: "mayo",
      6: "junio",
      7: "julio",
      8: "agosto",
      9: "septiembre",
      10: "octubre",
      11: "noviembre",
      12: "diciembre"
    };

    String month = months[monthNumber] ?? "Mes inválido";
    return "$day de $month";
  }

  /// CONVERSOR DE NUMEROS A PALABRA
  static String toDateMonth(int monthNumber) {
    Map<int, String> months = {
      1: "enero",
      2: "febrero",
      3: "marzo",
      4: "abril",
      5: "mayo",
      6: "junio",
      7: "julio",
      8: "agosto",
      9: "septiembre",
      10: "octubre",
      11: "noviembre",
      12: "diciembre"
    };

    String month = months[monthNumber] ?? "Mes inválido";
    return month;
  }

  static bool esNumero(String texto) {
    // Intenta convertir el texto a un número
    // Si hay una excepción al intentar convertir, significa que no es un número
    try {
      double.parse(texto);
      return true;
    } catch (e) {
      return false;
    }
  }
}