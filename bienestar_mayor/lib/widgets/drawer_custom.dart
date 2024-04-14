import 'package:bienestar_mayor/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/assets.dart';

class DrawerCustom extends StatelessWidget {
  final void Function() closeDrawer;
  const DrawerCustom(this.closeDrawer, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            const SizedBox(height: 80,),
            _drawerTile("Inicio", Icons.home, onTapTile: () {
              closeDrawer();
              /// TODO: Puedo comprobar si estoy en la pantalla principal?
              /// para usar el drawer en otras pantallas ademas de principal
              // Navigator.pushNamed(context, ROUTE_PRINCIPAL);
            }),
            const SizedBox(height: 20,),
            _drawerTile("Medicamentos", Icons.healing, subtitle: "Ver los medicamentos", onTapTile: () {
              closeDrawer();
              Navigator.pushNamed(context, ROUTE_MEDICAMENTOS);
            }),
            const SizedBox(height: 20,),
            _drawerTile("Calendario", Icons.date_range, onTapTile: () {
              closeDrawer();
              Navigator.pushNamed(context, ROUTE_CALENDAR);
            }),
            const SizedBox(height: 20,),
            _drawerTile("Ver seguimiento", Icons.follow_the_signs, onTapTile: () {
              closeDrawer();
              Navigator.pushNamed(context, ROUTE_SEGUIMIENTO);
            }),
            const SizedBox(height: 100,),
            _drawerTile("Llamar a emergencias", Icons.emergency, colorIcon: Colors.red, onTapTile: () {
              closeDrawer();
              Navigator.pushNamed(context, ROUTE_EMERGENCY);
            }),

            const Divider(height: 100,),
            const Text("BienestarMayor", style: TextStyle(fontSize: 26, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),),
            const SizedBox(height: 20,),
            SvgPicture.asset(Assets.imagesEyeClosed, width: 50,),
          ],
        ),
      ),
    );
  }



}

_drawerTile(String title, IconData icon, {String? subtitle, required void Function() onTapTile, Color? colorIcon}){
  final Text? textWidget;
  var color = colorIcon;

  (subtitle != null) ? textWidget = Text(subtitle) : textWidget = null;

  (colorIcon != null) ? color = colorIcon : color = Colors.black;

  return ListTile(
    leading: Icon(icon, size: 40,),
    title: Text(title),
    horizontalTitleGap: 20,
    iconColor: color,
    subtitle: textWidget,
    onTap: onTapTile,
  );
}
