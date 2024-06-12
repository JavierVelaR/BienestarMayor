import 'package:bienestar_mayor/model/evento.dart';
import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class PanelEventos extends StatefulWidget {
  final List<Evento> _events;
  final Function(Evento event) _function;

  const PanelEventos(this._events, this._function, {super.key});

  @override
  State<PanelEventos> createState() => _PanelEventosState();
}

class _PanelEventosState extends State<PanelEventos> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: widget._events.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Añade eventos a este día para verlos aquí",
                    style: TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey),
                  )
                ]),
              )
            : _listEventTiles());
  }

  _listEventTiles() {
    final events = widget._events;
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.8,
      child: ListView.separated(
        padding: const EdgeInsets.all(10),
        separatorBuilder: (_, __) => const SizedBox(
          height: 5,
        ),
        itemCount: events.length,

        // Listar cada evento del dia seleccionado
        itemBuilder: (_, index) => ListTile(
            title: Text(events[index].titulo),
            titleTextStyle: const TextStyle(fontSize: 22, color: Colors.black),
            subtitle: Text(events[index].descripcion),
            subtitleTextStyle:
                const TextStyle(fontSize: 16, color: Colors.black),
            tileColor: CustomColors.blancoFumee,
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black54), //the outline color
                borderRadius: BorderRadius.all(Radius.circular(12))),

            // Detalles en alertdialog al clickar un evento
            onTap: () async {
              final result = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text(
                    "Título",
                  ),
                  titleTextStyle: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 25),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          events[index].titulo,
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        if (events[index].descripcion != "") ...[
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Descripción",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            events[index].descripcion,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ],
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Fecha",
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        Text(
                          _formatDate(events[index].fecha),
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          // final result = await _dialogConfirm();
                          widget._function(events[index]);
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          "Borrar",
                          style: TextStyle(color: Colors.red),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cerrar")),
                  ],
                ),
              );
              if (result != null && result as bool && mounted) setState(() {});
            }),
      ),
    );
  }

  String _formatDate(String fecha) {
    // Parsear la fecha de entrada
    DateTime dateTime = DateTime.parse(fecha);

    // Lista de nombres de días y meses en español
    List<String> dias = [
      "Domingo",
      "Lunes",
      "Martes",
      "Miércoles",
      "Jueves",
      "Viernes",
      "Sábado"
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
    // " de ${dateTime.year}";

    return fechaFormateada;
  }
}
