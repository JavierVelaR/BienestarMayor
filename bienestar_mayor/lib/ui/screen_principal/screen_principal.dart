import 'package:bienestar_mayor/router.dart';
import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:bienestar_mayor/widgets/drawer_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../generated/assets.dart';

class ScreenPrincipal extends StatefulWidget {
  const ScreenPrincipal({super.key});

  @override
  State<ScreenPrincipal> createState() => _ScreenPrincipalState();
}

class _ScreenPrincipalState extends State<ScreenPrincipal> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      drawer: DrawerCustom( closeDrawer: () { scaffoldKey.currentState?.closeDrawer(); }, inicio: false,),
      body: SingleChildScrollView(padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _cardWithText("Gestionar medicamentos", CustomColors.azulFrancia, onTap: () {
                  Navigator.pushNamed(context, ROUTE_MEDICAMENTOS);
                }, Assets.imagesMedicamentos),

                _cardWithText("Ver calendario", CustomColors.verdeLima, onTap: () {
                  Navigator.pushNamed(context, ROUTE_CALENDAR);
                  },
                    Assets.imagesCalendario),

                _cardWithText("Ver seguimiento", CustomColors.berenjena, onTap: () {
                  Navigator.pushNamed(context, ROUTE_SEGUIMIENTO);
                }, Assets.imagesSeguimiento),

                _cardWithText("Llamar a emergencias", CustomColors.rojo, onTap: () {
                  /// TODO: Cambiar a numero de emergencias
                  launchUrlString('tel://12341');
                  // Navigator.pushNamed(context, ROUTE_EMERGENCY);
                }, Assets.imagesEmergencia),
              ],
            ),
          ),
        ),
    );
  }

  //////////////////////////////////
  // ELEMENTOS
  //////////////////////////////////

  _appBar(){
    return AppBar(
      title: const Text("BienestarMayor", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),),
      centerTitle: true,
      backgroundColor: CustomColors.verdeBosque,
      toolbarHeight: 70,
      shadowColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 40,),
        onPressed: (){ scaffoldKey.currentState?.openDrawer(); },),
      actions: [
        IconButton(onPressed: () { _showConfigUser();}, icon: const Icon(Icons.person), iconSize: 40, color: Colors.white,),
      ],
    );
  }

  _cardWithText(String text, Color color, String assetImage, { required void Function()? onTap, int width = 320}){
    return Column(
      children: [
        const SizedBox(height: 20,),
        Text(text, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),),
        const SizedBox(height: 10,),
        Container(
          width: width/1.1,
          height: 120,
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
              color: color,
              boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(-1, 1))]),
          alignment: Alignment.center,
          child: InkWell(
            onTap: onTap,
            child: SvgPicture.asset(assetImage),
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////
  // ACCIONES
  ////////////////////////////////////////////

  _showConfigUser(){
    Navigator.pushNamed(context, ROUTE_CONFIG_USER);
  }

}
