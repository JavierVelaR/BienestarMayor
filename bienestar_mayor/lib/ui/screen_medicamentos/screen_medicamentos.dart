import 'package:bienestar_mayor/router.dart';
import 'package:flutter/cupertino.dart';
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
    // TODO: Inicializar _listaMedicamentos con query a la db

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: _appBar(),
      drawer: DrawerCustom(
        inicio: true,
        closeDrawer: () {
          scaffoldKey.currentState?.closeDrawer();
        },
      ),

      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FittedBox(
          child: FloatingActionButton(
            foregroundColor: CustomColors.verdeBosque,
            backgroundColor: CustomColors.azulClaro,

            child: const Icon(Icons.medication, size: 40,),
            onPressed: () { Navigator.pushNamed(context, ROUTE_ADD_MEDICAMENTO); }
          ),
        ),
      ),

      body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              _listaMedicamentos.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height/3.5,),
                        const Text("Añade medicamentos para que se muestren aquí",
                          style: TextStyle(fontSize: 28, fontStyle: FontStyle.italic, color: Colors.grey),),
                      ]
                    )
                  : _listMedTiles(),
            ],
          )),
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


  /// TODO: que aparezcan en orden alfabético, supongo que haciendo un query a la db usando ORDER BY
  /// usando un query 'medicamentos'
  _listMedTiles(){
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) => const SizedBox(height: 15,),
      itemCount: _listaMedicamentos.length,
      itemBuilder: (_, index){
        final medicamento = _listaMedicamentos[index];
        return _medTile(medicamento);
      },
    );
  }

  _medTile(Medicamento med){
    return ListTile(
      /// TODO: Si es miligramos, icono de pastilla, si es mililitros icono de bote con cuchara
      leading: Icon(med.dosis.contains("mg") ? Icons.medication : Icons.medication_liquid, color: Colors.blue[400],),
      horizontalTitleGap: 50,
      title: Text(med.nombre),
      titleTextStyle: const TextStyle(fontSize: 22, color: Colors.black),
      subtitle: const Text("Subtitle"),
      subtitleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
      tileColor: CustomColors.blancoFumee,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black54), //the outline color
        borderRadius: BorderRadius.all( Radius.circular(12))),

      onTap: () { Navigator.pushNamed(context, ROUTE_MEDICAMENTO_DETAILS, arguments: med); },
    );
  }

}
