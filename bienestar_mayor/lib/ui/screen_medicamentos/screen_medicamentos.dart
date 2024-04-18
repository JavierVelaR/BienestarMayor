import 'package:bienestar_mayor/router.dart';
import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';
import '../../widgets/drawer_custom.dart';

class ScreenMedicamentos extends StatefulWidget {
  const ScreenMedicamentos({super.key});

  @override
  State<ScreenMedicamentos> createState() => _ScreenMedicamentosState();
}

class _ScreenMedicamentosState extends State<ScreenMedicamentos> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
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
      ),

      drawer: DrawerCustom(
        inicio: true,
        closeDrawer: () {
          scaffoldKey.currentState?.closeDrawer();
        },
      ),

      /// TODO: boton para añadir medicamento
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

      body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Center(
                child: const Text(
                  "Medicamentos:",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              _listMedTiles(),
            ],
          )),
    );
  }

  /// TODO: que aparezcan en orden alfabético, supongo que haciendo un query a la db usando ORDER BY
  /// usando un query 'medicamentos'
  _listMedTiles(){
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) => const SizedBox(height: 15,),
      itemCount: 3,
      itemBuilder: (_, index){
        return _medTile("nombre");
      },
    );
  }

  _medTile(String nombre){
    return ListTile(
      /// TODO: Si es miligramos, icono de pastilla, si es mililitros icono de bote con cuchara
      leading: const Icon(Icons.image),
      horizontalTitleGap: 50,
      title: Text(nombre),
      titleTextStyle: const TextStyle(fontSize: 22, color: Colors.black),
      subtitle: const Text("Subtitle"),
      subtitleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
      tileColor: CustomColors.blancoFumee,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.black54), //the outline color
        borderRadius: BorderRadius.all( Radius.circular(12))),

      onTap: () { Navigator.pushNamed(context, ROUTE_MEDICAMENTO_DETAILS); },
    );
  }

}
