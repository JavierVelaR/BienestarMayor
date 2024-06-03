import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class PanelHourDurationMed extends StatefulWidget {
  final Function() previousTab;
  final Function() nextTab;
  final Widget Function() radioButtonsFrequency;
  final Widget Function() seleccionarHora;
  final DateTimeRange selectedDayRange;
  final Widget Function() editDuration;

  const PanelHourDurationMed(
      this.previousTab,
      this.nextTab,
      this.radioButtonsFrequency,
      this.seleccionarHora,
      this.selectedDayRange,
      this.editDuration,
      {super.key});

  @override
  State<PanelHourDurationMed> createState() => _PanelHourDurationMedState();
}

class _PanelHourDurationMedState extends State<PanelHourDurationMed> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Cada cuantas horas:",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            widget.radioButtonsFrequency(),
            const SizedBox(
              height: 10,
            ),
            widget.seleccionarHora(),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Duración del tratamiento:",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Inicio: ${_toDate(widget.selectedDayRange.start.day, widget.selectedDayRange.start.month)}     "
              "Fin: ${_toDate(widget.selectedDayRange.end.day, widget.selectedDayRange.end.month)}",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: CustomColors.zafiro),
            ),
            const SizedBox(
              height: 20,
            ),
            widget.editDuration(),
            const SizedBox(
              height: 60,
            ),
            _buttons(),
          ],
        ),
      ),
    );
  }

  _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 60,
          child: FilledButton(
              onPressed: () {
                widget.previousTab();
              },
              child: const Text(
                "Anterior",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              )),
        ),
        const SizedBox(
          width: 25,
        ),
        SizedBox(
          width: 150,
          height: 60,
          child: FilledButton(
              onPressed: () {
                widget.nextTab();
              },
              child: const Text(
                "Siguiente",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              )),
        ),
      ],
    );
  }

  /// CONVERSOR DE NUMEROS A PALABRA
  String _toDate(int day, int monthNumber) {
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
}
