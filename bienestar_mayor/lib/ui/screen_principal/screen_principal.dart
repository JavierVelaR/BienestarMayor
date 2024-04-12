import 'package:bienestar_mayor/router.dart';
import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:bienestar_mayor/widgets/drawer_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../generated/assets.dart';

class ScreenPrincipal extends StatefulWidget {
  const ScreenPrincipal({super.key});

  @override
  State<ScreenPrincipal> createState() => _ScreenPrincipalState();
}

class _ScreenPrincipalState extends State<ScreenPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      drawer: const DrawerCustom(),
      body: SingleChildScrollView(padding: const EdgeInsets.all(10.0),
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _cardWithText("Gestionar medicamentos", CustomColors.azulFrancia, onTap: () {
                  debugPrint("---------> Pulsado el boton de calendario.");
                  Navigator.pushNamed(context, ROUTE_MEDICAMENTOS);
                }, Assets.imagesEyeClosed),

                _cardWithText("Ver calendario", CustomColors.verdeLima, onTap: () {
                  debugPrint("---------> Pulsado el boton de calendario.");
                  Navigator.pushNamed(context, ROUTE_CALENDAR);
                  },
                    Assets.imagesEyeClosed),

                _cardWithText("Ver seguimiento", CustomColors.berenjena, onTap: () {
                  debugPrint("---------> Pulsado el boton de calendario.");
                  Navigator.pushNamed(context, ROUTE_SEGUIMIENTO);
                }, Assets.imagesEyeClosed),

                _cardWithText("Llamar a emergencias", CustomColors.rojo, onTap: () {
                  debugPrint("---------> Pulsado el boton de calendario.");
                  Navigator.pushNamed(context, ROUTE_EMERGENCY);
                }, Assets.imagesEyeClosed, width: 180),
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
      title: const Text("BienestarMayor", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),),
      centerTitle: true,
      backgroundColor: CustomColors.verdeBosque,
      toolbarHeight: 70,
      shadowColor: Colors.black,
      // leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white, size: 55,), onPressed: (){ _showMenu(); },),
      actions: [
        IconButton(onPressed: () { _showAccount();}, icon: const Icon(Icons.person), iconSize: 40, color: Colors.white,),
      ],
    );
  }

  // _drawer(){
  //   return Drawer(
  //     width: 250,
  //     child: Container(
  //       alignment: Alignment.center,
  //       decoration: const BoxDecoration(color: Colors.white),
  //       child: Column(
  //         children: [
  //           const SizedBox(height: 80,),
  //           _drawerTile("Medicamentos", Icons.healing, subtitle: "Ver los medicamentos", onTapTile: (){}),
  //           const SizedBox(height: 20,),
  //           _drawerTile("Calendario", Icons.date_range, onTapTile: (){}),
  //           const SizedBox(height: 20,),
  //           _drawerTile("Ver seguimiento", Icons.follow_the_signs, onTapTile: (){}),
  //           const SizedBox(height: 100,),
  //           _drawerTile("Llamar a emergencias", Icons.emergency, colorIcon: Colors.red, onTapTile: (){}),
  //
  //           const Divider(height: 100,),
  //           const Text("BienestarMayor", style: TextStyle(fontSize: 26, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),),
  //           const SizedBox(height: 20,),
  //           SvgPicture.asset(Assets.imagesEyeClosed, width: 50,),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // _drawerTile(String title, IconData icon, {String? subtitle, required void Function() onTapTile, Color? colorIcon}){
  //   final Text? textWidget;
  //   var color = colorIcon;
  //
  //   (subtitle != null) ? textWidget = Text(subtitle) : textWidget = null;
  //
  //   (colorIcon != null) ? color = colorIcon : color = Colors.black;
  //
  //   return ListTile(
  //     leading: Icon(icon, size: 40,),
  //     title: Text(title),
  //     horizontalTitleGap: 20,
  //     iconColor: color,
  //     subtitle: textWidget,
  //     onTap: onTapTile,
  //   );
  // }

  _cardWithText(String text, Color color, String assetImage, { required void Function()? onTap, int width = 320}){
    return Column(
      children: [
        const SizedBox(height: 20,),
        Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
        const SizedBox(height: 10,),
        Container(
          width: width.toDouble(),
          height: 120,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
          alignment: Alignment.center,
          child: InkWell(
            onTap: onTap,
            child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
          ),
        ),
      ],
    );
  }
  
  
  ////////////////////////////////////////////
  // ACCIONES
  ////////////////////////////////////////////

  // _showMenu(){
  //   debugPrint("Se ha pulsado el icono del menu");
  // }

  _showAccount(){
    debugPrint("Se ha pulsado el icono de la cuenta");
  }

}
