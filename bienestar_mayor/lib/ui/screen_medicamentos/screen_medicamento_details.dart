import 'package:bienestar_mayor/database/dao/medicamento_dao.dart';
import 'package:bienestar_mayor/database/dao/recordatorio_dao.dart';
import 'package:bienestar_mayor/database/db_helper.dart';
import 'package:bienestar_mayor/model/recordatorio.dart';
import 'package:flutter/material.dart';

import '../../model/medicamento.dart';
import '../../theme/custom_colors.dart';

class ScreenMedicamentoDetails extends StatefulWidget {
  final Medicamento _medicamento;

  const ScreenMedicamentoDetails(this._medicamento, {super.key});

  @override
  State<ScreenMedicamentoDetails> createState() =>
      _ScreenMedicamentoDetailsState();
}

class _ScreenMedicamentoDetailsState extends State<ScreenMedicamentoDetails> {
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
      body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              widget._medicamento.foto != null
                  ? Container(
                      ///TODO: si tiene imagen, mostrarla y si no, poner boton para añadirla
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height / 3,
                      alignment: Alignment.center,
                      // child: Image(image: AssetImage,),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Añadir imagen:",
                          style: TextStyle(fontSize: 24),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              /// TODO: hacer update al medicamento añadiendo foto

                            },
                            child: const Icon(Icons.image))
                      ],
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
          )),
    );
  }

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
                                  final query = await DbHelper.instance.db.query(
                                      RecordatorioDao().tableName, where: "id_medicamento = ?", whereArgs: [widget._medicamento.id]);

                                  final listaRecordatorios = query.map((e) => Recordatorio.fromMap(e)).toList();

                                  for(Recordatorio rec in listaRecordatorios){
                                    RecordatorioDao().deleteRecordatorio(rec);
                                    // debugPrint("Recordatorio eliminado: id -> ${rec.id}");
                                  }

                                  MedicamentoDao().deleteMedicamento(widget._medicamento);

                                  /// TODO: mostrar texto que se ha eliminado con exito


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
}
