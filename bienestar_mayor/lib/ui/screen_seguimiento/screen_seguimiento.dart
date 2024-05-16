import 'package:bienestar_mayor/database/db_helper.dart';
import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:bienestar_mayor/widgets/drawer_custom.dart';
import 'package:flutter/material.dart';

class ScreenSeguimiento extends StatefulWidget {
  const ScreenSeguimiento({super.key});

  @override
  State<ScreenSeguimiento> createState() => _ScreenSeguimientoState();
}

class _ScreenSeguimientoState extends State<ScreenSeguimiento> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  // List<dynamic> _listaHistorial = List.empty();

  List<dynamic> _listaHistorial = [
    {
      "id": 1,
      "nombre_medicamento": "ibuprofeno",
      "hora": "2024-04-30 17:00",
      "tomado": 1,
    },
    {
      "id": 2,
      "nombre_medicamento": "paracetamol",
      "hora": "2024-05-01 22:00",
      "tomado": 0,
    }
  ];

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(),
      drawer: DrawerCustom(inicio: true, closeDrawer: () { scaffoldKey.currentState?.closeDrawer(); },),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: _listaHistorial.isEmpty
            ? const Center(
                child: Text(
                  "Cuando añadas medicamentos, aparecerá aquí su seguimiento",
                  style: TextStyle(
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey),
                ),
              )
            : _listHistorial(),
      ),
    );
  }

  _appBar() => AppBar(
        title: const Text("BienestarMayor", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),),
      centerTitle: true,
      backgroundColor: CustomColors.berenjena,
      toolbarHeight: 70,
      shadowColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 40,),
        onPressed: (){ scaffoldKey.currentState?.openDrawer(); },),
    );

  _listHistorial() => ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (_, __) => const SizedBox(
          height: 15,
        ),
        itemCount: _listaHistorial.length,
        itemBuilder: (_, index) {
          final historic = _listaHistorial[index];
          return _historicTile(historic);
        },
      );

  _historicTile(historic) => ListTile(
        leading: Icon(
          Icons.newspaper,
          color: Colors.grey[400],
          size: 40,
        ),
        horizontalTitleGap: 20,
        title: Text("${historic["nombre_medicamento"]}"),
        titleTextStyle: const TextStyle(fontSize: 22, color: Colors.black),
        subtitle: Text("${historic["hora"]}"),
        subtitleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        trailing: historic["tomado"] == 0
            ? const Icon(
                Icons.gpp_bad,
                color: Colors.red,
                size: 45,
              )
            : const Icon(
                Icons.verified_user,
                color: Colors.green,
                size: 45,
              ),
        tileColor: CustomColors.blancoFumee,
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black54), //the outline color
            borderRadius: BorderRadius.all(Radius.circular(12))),
        onTap: () {
          // Dialog detalles ¿?
        },
      );

  Future<List<dynamic>> _getTomasPasadas(DateTime fecha) async {
    final db = DbHelper().db;

    // Consulta SQL para obtener eventos cuya fecha sea posterior a la fecha especificada
    final List<Map<String, dynamic>> historialMapList = await db.rawQuery('''
    SELECT h.id, m.nombre, r.hora, h.tomado
    FROM Historial h
    INNER JOIN Recordatorios r ON h.id_recordatorio = r.id
    INNER JOIN Medicamentos m ON r.id_medicamento = m.id
  ''', [
      fecha.toIso8601String()
    ]); // Convertir la fecha a un formato compatible con SQLite

    // Convertir Mapas a Lista de Objetos Evento
    List<dynamic> historialList = historialMapList.map((historialMap) {
      return {
        "id": historialMap['id'],
        "hora": historialMap['hora'],
        "nombre_medicamento": historialMap['nombre'],
        "tomado": historialMap['tomado'],
      };
    }).toList();

    return historialList;
  }

  _cargarHistorial() async {
    final list = await _getTomasPasadas(DateTime.now());
    setState(() {
      _listaHistorial = list;
    });
  }
}
