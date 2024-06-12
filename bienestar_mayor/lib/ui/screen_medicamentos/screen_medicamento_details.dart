import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:bienestar_mayor/database/dao/historial_dao.dart';
import 'package:bienestar_mayor/database/dao/medicamento_dao.dart';
import 'package:bienestar_mayor/database/dao/recordatorio_dao.dart';
import 'package:bienestar_mayor/database/db_helper.dart';
import 'package:bienestar_mayor/model/historial.dart';
import 'package:bienestar_mayor/model/recordatorio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/medicamento.dart';
import '../../theme/custom_colors.dart';

class ScreenMedicamentoDetails extends StatefulWidget {
  final Medicamento _medicamento;
  final Function() _function;

  const ScreenMedicamentoDetails(this._medicamento, this._function,
      {super.key});

  @override
  State<ScreenMedicamentoDetails> createState() =>
      _ScreenMedicamentoDetailsState();
}

class _ScreenMedicamentoDetailsState extends State<ScreenMedicamentoDetails> {
  String _fotoPath = "";
  XFile? _pickedFile;
  bool _tieneFoto = false;
  String _horasTomaText = "";

  @override
  void initState() {
    super.initState();
    if (widget._medicamento.foto != null)
      _fotoPath = XFile(widget._medicamento.foto!).path;
    if (_fotoPath.isNotEmpty) _tieneFoto = true;

    _getHorasToma();
  }

  // TODO: Mejorar recuadro de foto, ver si está vertical o en paisaje, que muestre las horas de toma
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles", style: TextStyle(fontSize: 26)),
        centerTitle: true,
        backgroundColor: CustomColors.azulFrancia,
        toolbarHeight: 70,
        shadowColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _floatingActionButton(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    // TODO: al clickar en la imagen, que se vea en pantalla completa
                    _fotoPath.isNotEmpty
                        ? Container(
                            width: MediaQuery.sizeOf(context).width / 1.5,
                            height: MediaQuery.sizeOf(context).height / 3.75,
                            alignment: Alignment.center,
                            // decoration: BoxDecoration(
                            //   border: Border.all(color: Colors.black),
                            //   borderRadius: const BorderRadius.all(Radius.circular(20))
                            // ),
                            child: Image.file(File(XFile(_fotoPath).path)),
                          )
                        : Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30))),
                                  child: const Icon(
                                    Icons.medication,
                                    size: 200,
                                    color: Colors.grey,
                                  )),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          _fotoPath.isNotEmpty
                              ? "Cambiar imagen:"
                              : "Añadir imagen:",
                          style: const TextStyle(
                              fontSize: 24, color: CustomColors.grisPizarra),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        _botonCambiarImagen(),
                      ],
                    )
                  ],
                ),
              ],
            ),
            const Divider(
              color: CustomColors.azulFrancia,
            ),
            _infoField("Nombre", widget._medicamento.nombre),
            const SizedBox(height: 5),
            _infoField("Dosis", widget._medicamento.dosis),
            const SizedBox(height: 5),
            _infoField(
                "Frecuencia", "cada ${widget._medicamento.frecuencia} horas"),
            const SizedBox(height: 5),
            const Text(
              "Horas de toma:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              _horasTomaText,
              style: const TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 5),
            _infoField("Duración",
                "${widget._medicamento.duracion} ${widget._medicamento.duracion < 2 ? "día" : "días"}"),
          ],
        ),
      ),
    );
  }

  _infoField(String name, String info) => Row(
        children: [
          Text(
            "$name: ",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            info,
            style: const TextStyle(
              fontSize: 24,
              // fontWeight: FontWeight.bold
            ),
          ),
        ],
      );

  _floatingActionButton() => SizedBox(
        height: 80,
        width: 80,
        child: FittedBox(
          child: FloatingActionButton(
              foregroundColor: CustomColors.rojoLadrillo,
              backgroundColor: CustomColors.salmonClaro,
              child: const Icon(
                Icons.delete,
                size: 35,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                              "¿Seguro que quieres eliminar el medicamento y sus recordatorios?"),
                          titleTextStyle: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  // Eliminar medicamento y recordatorios de la db
                                  final query = await DbHelper().db.query(
                                      RecordatorioDao().tableName,
                                      where: "id_medicamento = ?",
                                      whereArgs: [widget._medicamento.id]);

                                  final listaRecordatorios = query
                                      .map((e) => Recordatorio.fromMap(e))
                                      .toList();

                                  for (Recordatorio rec in listaRecordatorios) {
                                    final queryHistorial = await DbHelper()
                                        .db
                                        .query(HistorialDao().tableName,
                                            where: "id_recordatorio = ?",
                                            whereArgs: [rec.id]);

                                    final historial = queryHistorial
                                        .map((e) => Historial.fromMap(e))
                                        .toList();

                                    if (historial.isNotEmpty) {
                                      HistorialDao()
                                          .deleteHistorial(historial[0]);
                                    }

                                    // Eliminar recordatorio
                                    RecordatorioDao().deleteRecordatorio(rec);
                                    // debugPrint("Recordatorio eliminado: id -> ${rec.id}");

                                    // Eliminar las alarmas programadas de ese medicamento
                                    Alarm.stop(rec.id);
                                  }

                                  MedicamentoDao()
                                      .deleteMedicamento(widget._medicamento);

                                  // Salir de Dialog y salir a pantalla de listado de medicamentos
                                  Navigator.pop(context);
                                  Navigator.pop(context, true);
                                },
                                child: const Text("Sí",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red))),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancelar",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ))),
                          ],
                        ));
              }),
        ),
      );

  _botonCambiarImagen() => ElevatedButton(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: _tieneFoto
                ? const Text("¿Quieres cambiar la foto?")
                : const Text(
                    "¿Quieres tomar una foto o cargarla de la galería?"),
            alignment: Alignment.center,
            shadowColor: Colors.black,
            elevation: 10,
            actionsAlignment: MainAxisAlignment.end,
            actions: [
              TextButton(
                  onPressed: () async {
                    _pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (_pickedFile != null && _pickedFile!.path.isNotEmpty) {
                      setState(() {
                        _fotoPath = _pickedFile!.path;
                      });

                      // Actualizar medicamento de la db, añadiendole foto
                      Medicamento updatedMed =
                          widget._medicamento.copyWith(foto: _fotoPath);
                      _addFoto(updatedMed);

                      // Llamar a la funcion de la pantalla padre, actualizando los medicamentos de la lista
                      widget._function();

                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Tomar foto")),
              TextButton(
                  onPressed: () async {
                    _pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (_pickedFile != null && _pickedFile!.path.isNotEmpty) {
                      setState(() {
                        _fotoPath = _pickedFile!.path;
                      });

                      Medicamento updatedMed =
                          widget._medicamento.copyWith(foto: _fotoPath);
                      _addFoto(updatedMed);
                      widget._function();

                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Cargar foto")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
            ],
          ),
        );
      },
      child: const Icon(
        Icons.image,
      ));

  _addFoto(Medicamento med) {
    MedicamentoDao().updateMedicamento(med);
  }

  _getHorasToma() {
    // Conseguir la hora de inicio con el primer recordatorio del medicamento
    DbHelper().db.query(RecordatorioDao().tableName,
        where: "id_medicamento = ?",
        whereArgs: [widget._medicamento.id]).then((query) {
      final recordatorio =
          query.map((map) => Recordatorio.fromMap(map)).toList();
      for (int i = 0; i < 24 / widget._medicamento.frecuencia; i++) {
        if ((i == 0 && 24 / widget._medicamento.frecuencia == 1) ||
            (i == 24 / widget._medicamento.frecuencia - 1)) {
          _horasTomaText += recordatorio[i].hora.split(' ').last;
        } else {
          _horasTomaText += "${recordatorio[i].hora.split(' ').last}, \t";
        }
      }

      setState(() {});
    });
  }
}
