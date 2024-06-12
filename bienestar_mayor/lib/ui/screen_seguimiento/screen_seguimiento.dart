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

  List<dynamic> _listaHistorial = List.empty();

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

  _historicTile(historic) {
    final nombre = "${historic["nombre_medicamento"]}";
    final fechaHora = "${historic["hora"]}";
    final tomado = historic["tomado"];

    return ListTile(
      leading: Icon(
          Icons.newspaper,
          color: Colors.grey[400],
          size: 40,
        ),
        horizontalTitleGap: 20,
      title: Text(nombre),
      titleTextStyle: const TextStyle(fontSize: 22, color: Colors.black),
      subtitle: Text(fechaHora),
      subtitleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
      trailing: tomado == 1
          ? const Icon(
                Icons.verified_user,
                color: Colors.green,
                size: 45,
              )
            : const Icon(
                Icons.gpp_bad,
                color: Colors.red,
                size: 45,
              ),
        tileColor: CustomColors.blancoFumee,
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black54), //the outline color
            borderRadius: BorderRadius.all(Radius.circular(12))),
        onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              "Medicamento",
            ),
            titleTextStyle: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 25),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Fecha y hora",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Text(
                    "El ${_formatDateHour(fechaHora)[0]}",
                    style: const TextStyle(fontSize: 22),
                  ),
                  Text(
                    "a las ${_formatDateHour(fechaHora)[1]}",
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Toma realizada",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  tomado == 1
                      ? const Text(
                          "Sí",
                          style: TextStyle(fontSize: 22, color: Colors.green),
                        )
                      : const Text(
                          "No",
                          style: TextStyle(fontSize: 22, color: Colors.red),
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      );
  }

  Future<List<dynamic>> _getTomasPasadas(DateTime fecha) async {
    final String formattedDate =
        "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-"
        "${fecha.day.toString().padLeft(2, '0')} ${fecha.hour.toString().padLeft(2, '0')}:"
        "${fecha.minute.toString().padLeft(2, '0')}";

    final db = DbHelper().db;

    // final query = await db.query(HistorialDao().tableName);
    //
    // final lista = query.map((e) => Historial.fromMap(e)).toList();
    //
    // return lista;

    // Consulta SQL para obtener eventos cuya fecha sea posterior a la fecha especificada
    final List<Map<String, dynamic>> historialMapList = await db.rawQuery('''
    SELECT h.id, m.nombre, r.hora, h.tomado
    FROM historial h
    INNER JOIN recordatorios r ON h.id_recordatorio = r.id
    INNER JOIN medicamentos m ON r.id_medicamento = m.id
    -- WHERE r.hora < ?
  ''',
      // [formattedDate]
    );

    // Convertir Mapas a Lista de Objetos Evento
    List<dynamic> historialList = historialMapList.map((historialMap) {
      return {
        "id": historialMap['id'],
        "hora": historialMap['hora'],
        "nombre_medicamento": historialMap['nombre'],
        "tomado": historialMap['tomado'] ?? false,
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

  // List<String> _formatDateHour(String fechaHora) {
  //   // Parsear la fecha y hora de entrada
  //   DateTime dateTime = DateTime.parse(fechaHora);
  //
  //   // Lista de nombres de días y meses en español
  //   List<String> dias = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];
  //   List<String> meses = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"];
  //
  //   // Obtener el nombre del día y el nombre del mes
  //   String diaNombre = dias[dateTime.weekday % 7];
  //   String mesNombre = meses[dateTime.month - 1];
  //
  //   // Formatear la fecha
  //   String fechaFormateada = "$diaNombre, ${dateTime.day} de $mesNombre";
  //
  //   // Formatear la hora
  //   String horaFormateada = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  //
  //   return [fechaFormateada, horaFormateada];
  // }

  List<String> _formatDateHour(String fechaHora) {
    // Asegurarse de que el formato de la cadena sea correcto (YYYY-MM-DD HH:MM)
    List<String> partes = fechaHora.split(' ');
    List<String> fechaPartes = partes[0].split('-');
    List<String> horaPartes = partes[1].split(':');

    // Normalizar los valores a dos dígitos donde sea necesario
    String anio = fechaPartes[0];
    String mes = fechaPartes[1].padLeft(2, '0');
    String dia = fechaPartes[2].padLeft(2, '0');
    String hora = horaPartes[0].padLeft(2, '0');
    String minuto = horaPartes[1].padLeft(2, '0');

    // Reconstruir la fecha y hora en formato válido para DateTime
    String fechaHoraNormalizada = '$anio-$mes-$dia $hora:$minuto';
    DateTime dateTime = DateTime.parse(fechaHoraNormalizada);

    // Lista de nombres de días y meses en español
    List<String> dias = [
      "domingo",
      "lunes",
      "martes",
      "miércoles",
      "jueves",
      "viernes",
      "sábado"
    ];
    List<String> meses = [
      "enero",
      "febrero",
      "marzo",
      "abril",
      "mayo",
      "junio",
      "julio",
      "agosto",
      "septiembre",
      "octubre",
      "noviembre",
      "diciembre"
    ];

    // Obtener el nombre del día y el nombre del mes
    String diaNombre = dias[dateTime.weekday % 7];
    String mesNombre = meses[dateTime.month - 1];

    // Formatear la fecha
    String fechaFormateada = "$diaNombre, ${dateTime.day} de $mesNombre";

    // Formatear la hora
    String horaFormateada =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    return [fechaFormateada, horaFormateada];
  }
}
