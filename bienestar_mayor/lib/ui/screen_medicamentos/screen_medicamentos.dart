import 'package:bienestar_mayor/database/dao/medicamento_dao.dart';
import 'package:bienestar_mayor/database/db_helper.dart';
import 'package:bienestar_mayor/router.dart';
import 'package:flutter/material.dart';

import '../../model/medicamento.dart';
import '../../theme/custom_colors.dart';
import '../../widgets/drawer_custom.dart';

class ScreenMedicamentos extends StatefulWidget {
  const ScreenMedicamentos({super.key});

  @override
  State<ScreenMedicamentos> createState() => _ScreenMedicamentosState();
}

class _ScreenMedicamentosState extends State<ScreenMedicamentos> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<Medicamento> _listaMedicamentos = List.empty();

  @override
  void initState() {
    super.initState();
    _cargarMedicamentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(),
      drawer: _drawer(),
      floatingActionButton: _floatingActionButton(),
      body: Padding(
          padding: const EdgeInsets.all(25),
          child: _listaMedicamentos.isEmpty
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.5,
                  ),
                  const Text(
                    "Añade medicamentos para que se muestren aquí",
                    style: TextStyle(
                        fontSize: 28,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey),
                  ),
                ])
              : _listMedTiles()),
    );
  }

  _appBar() => AppBar(
        title: const Text("Medicamentos", style: TextStyle(fontSize: 26)),
        centerTitle: true,
        backgroundColor: CustomColors.azulFrancia,
        toolbarHeight: 70,
        shadowColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
      );

  _drawer() => DrawerCustom(
        inicio: true,
        closeDrawer: () {
          scaffoldKey.currentState?.closeDrawer();
        },
      );

  _floatingActionButton() => SizedBox(
        height: 80,
        width: 80,
        child: FittedBox(
          child: FloatingActionButton(
              foregroundColor: CustomColors.verdeBosque,
              backgroundColor: CustomColors.azulClaro,
              child: const Icon(
                Icons.medication,
                size: 40,
              ),
              onPressed: () async {
                final result = await Navigator.pushNamed(context, ROUTE_ADD_MEDICAMENTO);
                if (result != null  &&  result as bool) _cargarMedicamentos();

              }),
        ),
      );

  ////////////////////////////// LISTAR MEDICAMENTOS ////////////////////////////////
  _listMedTiles() {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) => const SizedBox(
        height: 15,
      ),
      itemCount: _listaMedicamentos.length,
      itemBuilder: (_, index) {
        final medicamento = _listaMedicamentos[index];
        return _medTile(medicamento);
      },
    );
  }

  _medTile(Medicamento med) {
    return ListTile(
      leading: med.dosis.contains("mg")
          ? Icon(
              Icons.medication,
              color: Colors.red[400],
              size: 40,
            )
          : Icon(
              Icons.medication_liquid,
              color: Colors.blue[400],
              size: 40,
            ),
      horizontalTitleGap: 20,
      title: Text(med.nombre),
      titleTextStyle: const TextStyle(fontSize: 22, color: Colors.black),
      subtitle: Text("${med.dosis}, cada ${med.frecuencia} horas"),
      subtitleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
      tileColor: CustomColors.blancoFumee,
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black54), //the outline color
          borderRadius: BorderRadius.all(Radius.circular(12))),
      onTap: () async{
        final result = await Navigator.pushNamed(context, ROUTE_MEDICAMENTO_DETAILS, arguments: med);
        if (result != null  &&  result as bool) _cargarMedicamentos();
      },
    );
  }

  //////////////////////////////// BASE DE DATOS ////////////////////////////////////

  /// TODO: que haya opciones de ordenar (por id, por nombre, por primero en acabar)
  _cargarMedicamentos() async {
    // Lista ordenada por id
    // List<Medicamento> meds = await MedicamentoDao().readAllMedicamentos();

    // lista ordenada alfabéticamente
    final medsMap = await DbHelper.instance.db
        .query(MedicamentoDao().tableName, orderBy: 'nombre ASC');
    List<Medicamento> meds =
        medsMap.map((e) => Medicamento.fromMap(e)).toList();

    setState(() {
      _listaMedicamentos = meds;
    });
  }
}
