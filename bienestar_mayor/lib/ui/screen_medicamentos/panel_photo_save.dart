import 'package:flutter/material.dart';

class PanelPhotoSaveMed extends StatefulWidget {
  final Function() previousTab;
  final Widget Function() addPhoto;
  final Widget Function() buttonSave;

  const PanelPhotoSaveMed(this.previousTab, this.addPhoto, this.buttonSave,
      {super.key});

  @override
  State<PanelPhotoSaveMed> createState() => _PanelPhotoSaveMedState();
}

class _PanelPhotoSaveMedState extends State<PanelPhotoSaveMed> {
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
              height: 100,
            ),
            const Align(
                alignment: Alignment.center,
                child: Text(
                  "Puedes añadir una foto para recordar el medicamento",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                )),
            const SizedBox(
              height: 15,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Es opcional *",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.red),
              ),
            ),
            const SizedBox(
              height: 65,
            ),
            widget.addPhoto(),
            const SizedBox(
              height: 165,
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
        widget.buttonSave(),
      ],
    );
  }
}
