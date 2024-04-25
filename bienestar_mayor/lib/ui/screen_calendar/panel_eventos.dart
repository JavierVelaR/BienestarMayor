import 'package:bienestar_mayor/model/evento.dart';
import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PanelEventos extends StatefulWidget {
  final List<Evento> _events;
  const PanelEventos(this._events, {super.key});

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
              child: Column(
                  children: [SizedBox(height: 50,),
                    Text("Añade eventos a este día para verlos aquí",
                      style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic, color: Colors.grey),)]),
            )
          : Column(
            children: [
              const Text("Eventos:", style: TextStyle(fontSize: 22),),
              _listEventTiles(),
            ],
          )

    );
  }

  /// TODO: Sobresalen los eventos
  _listEventTiles(){
    final events = widget._events;
    return SizedBox(
      height: MediaQuery.of(context).size.height/4.3,
      child: ListView.separated(
        padding: const EdgeInsets.all(10),
        separatorBuilder: (_, __) => const SizedBox(height: 5,),
        itemCount: events.length,
        itemBuilder: (_, index) => _eventTile(events[index]),
      ),
    );
  }

  // TODO: añadir segun la categoria, un leading de icono con color de la categoria
  _eventTile(Evento event){
    return ListTile(
      title: Text(event.titulo),
      titleTextStyle: const TextStyle(fontSize: 22, color: Colors.black),
      subtitle: Text(event.descripcion),
      subtitleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
      tileColor: CustomColors.blancoFumee,
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black54), //the outline color
          borderRadius: BorderRadius.all(Radius.circular(12))),
      onTap: _clickTile(event),
    );
  }

 /////////////////////////////////////////// EVENTOS ////////////////////////////////////////////

  ///TODO: al clickar un tile, que salgan los detalles en AlertDialog
  _clickTile(Evento event){
    // showDialog(
    //   context: context,
    //   builder: (_) => AlertDialog(
    //     title: Text(event.titulo, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Colors.black),),
    //   ),
    // );
  }

}
