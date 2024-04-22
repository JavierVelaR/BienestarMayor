import 'package:bienestar_mayor/widgets/drawer_custom.dart';
import 'package:flutter/material.dart';

import '../../model/recordatorio.dart';
import '../../theme/custom_colors.dart';

class ScreenSeguimiento extends StatefulWidget {
  const ScreenSeguimiento({super.key});

  @override
  State<ScreenSeguimiento> createState() => _ScreenSeguimientoState();
}

class _ScreenSeguimientoState extends State<ScreenSeguimiento> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Recordatorio> _listaRecordatorios = List.empty();

  @override
  void initState() {
    super.initState();
    ///TODO: cargar lista desde db

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(),
      drawer: DrawerCustom(inicio: true, closeDrawer: () { scaffoldKey.currentState?.closeDrawer(); },),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            _listaRecordatorios.isEmpty
                ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/3.5,),
                  const Text("Añade medicamentos para que se muestren aquí",
                    style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic, color: Colors.grey),),
                ]
            ) : _listRecordatorios(),
          ],
        ),
      ),
    );
  }

  _appBar(){
    return AppBar(
      title: const Text("BienestarMayor", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),),
      centerTitle: true,
      backgroundColor: CustomColors.berenjena,
      toolbarHeight: 70,
      shadowColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 40,),
        onPressed: (){ scaffoldKey.currentState?.openDrawer(); },),
    );
  }

  _listRecordatorios(){

  }

}
