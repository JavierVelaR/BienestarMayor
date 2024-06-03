import 'package:flutter/material.dart';

class PanelNameDoseMed extends StatefulWidget {
  final Function() nextTab;
  final Widget Function() editName;
  final Widget Function() editDosis;

  const PanelNameDoseMed(this.nextTab, this.editName, this.editDosis,
      {super.key});

  @override
  State<PanelNameDoseMed> createState() => _PanelNameDoseMedState();
}

class _PanelNameDoseMedState extends State<PanelNameDoseMed> {
  final _nameController = TextEditingController();
  final _dosisController = TextEditingController();
  String _tipoDosis = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 70,
            ),
            const Text(
              "Nombre del medicamento:",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            widget.editName(),
            const SizedBox(
              height: 60,
            ),
            const Text(
              "Cantidad de dosis:",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            widget.editDosis(),
            const SizedBox(
              height: 120,
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
                Navigator.of(context).pop();
              },
              child: const Text(
                "Salir",
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
}
