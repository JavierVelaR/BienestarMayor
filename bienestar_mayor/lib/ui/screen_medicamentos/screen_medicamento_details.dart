import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:bienestar_mayor/database/dao/medicamento_dao.dart';
import 'package:bienestar_mayor/database/dao/recordatorio_dao.dart';
import 'package:bienestar_mayor/database/db_helper.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget._medicamento.foto != null)
      _fotoPath = XFile(widget._medicamento.foto!).path;
    if (_fotoPath.isNotEmpty) _tieneFoto = true;
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _fotoPath.isNotEmpty
                    ? Column(children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width / 1.75,
                          height: MediaQuery.sizeOf(context).height / 3.75,
                          alignment: Alignment.center,
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.black),
                          //   borderRadius: const BorderRadius.all(Radius.circular(20))
                          // ),
                          child: Image.file(File(XFile(_fotoPath).path)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "Cambiar imagen:",
                              style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            _botonCambiarImagen(),
                          ],
                        ),
                      ])
                    : Column(
                        children: [
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
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Añadir imagen:",
                                style: TextStyle(fontSize: 24),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              _botonCambiarImagen(),
                            ],
                          ),
                        ],
                    ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Nombre: ${widget._medicamento.nombre}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Dosis: ${widget._medicamento.dosis}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Frecuencia: cada ${widget._medicamento.frecuencia} horas",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Duración: ${widget._medicamento.duracion} días",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // todo: modificar horas de toma de medicamento ¿? no creo

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
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancelar",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ))),
                            TextButton(
                                onPressed: () async{
                                  // Eliminar medicamento y recordatorios de la db
                                  final query = await DbHelper().db.query(
                                      RecordatorioDao().tableName, where: "id_medicamento = ?", whereArgs: [widget._medicamento.id]);

                                  final listaRecordatorios = query.map((e) => Recordatorio.fromMap(e)).toList();

                                  for(Recordatorio rec in listaRecordatorios){
                                    RecordatorioDao().deleteRecordatorio(rec);
                                    // debugPrint("Recordatorio eliminado: id -> ${rec.id}");

                                    // Eliminar las alarmas programadas de ese medicamento
                                    Alarm.stop(rec.id);
                                  }

                                  MedicamentoDao().deleteMedicamento(widget._medicamento);

                                  // /// TODO: mostrar texto que se ha eliminado con exito ¿?
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (_) => AlertDialog(
                                  //       title: const Text("Se ha borrado con éxito"),
                                  //       actions: [
                                  //         TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("Vale"))
                                  //       ],
                                  //     ),
                                  //     );

                                  // Salir de Dialog y salir a pantalla de listado de medicamentos
                                  Navigator.pop(context);
                                  Navigator.pop(context, true);
                                },
                                child: const Text("Sí",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red))),
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
}
