import 'package:bienestar_mayor/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../generated/assets.dart';

class DrawerCustom extends StatelessWidget {
  final void Function() closeDrawer;
  // Si inicio es true, quiere decir que en el drawer habra un Tile para ir a inicio, si es false habra un hueco
  final bool inicio;
  const DrawerCustom({super.key, required this.closeDrawer, this.inicio = true});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            const SizedBox(height: 30,),
            (inicio)
                ? _drawerTile("Inicio", Icons.home, onTapTile: () {
                    closeDrawer();
                    // Navigator.pushNamed(context, ROUTE_PRINCIPAL);
                    Navigator.pop(context);
                  })
            // _drawerTile("Volver", Icons.arrow_back, onTapTile: (){ closeDrawer(); Navigator.pop(context); })
                : const SizedBox(height: 50,),

            const SizedBox(height: 20,),
            _drawerTile("Medicamentos", Icons.healing, subtitle: "Ver los medicamentos", onTapTile: () {
              closeDrawer();
              (inicio) ? Navigator.popAndPushNamed(context, ROUTE_MEDICAMENTOS)
                  : Navigator.pushNamed(context, ROUTE_MEDICAMENTOS);
            }),
            const SizedBox(height: 20,),
            _drawerTile("Calendario", Icons.date_range, onTapTile: () {
              closeDrawer();
              (inicio) ? Navigator.popAndPushNamed(context, ROUTE_CALENDAR)
                  : Navigator.pushNamed(context, ROUTE_CALENDAR);
            }),
            const SizedBox(height: 20,),
            _drawerTile("Ver seguimiento", Icons.follow_the_signs, onTapTile: () {
              closeDrawer();

              (inicio) ? Navigator.popAndPushNamed(context, ROUTE_SEGUIMIENTO)
                  : Navigator.pushNamed(context, ROUTE_SEGUIMIENTO);
            }),
            const SizedBox(height: 100,),
            _drawerTile("Llamar a emergencias", Icons.emergency, colorIcon: Colors.red, onTapTile: () {
              closeDrawer();
              // Navigator.pushNamed(context, ROUTE_EMERGENCY);
              launchUrlString('tel://061');
            }),

            const Divider(height: 50,),
            SvgPicture.asset(Assets.imagesBienestarMayorLogo, width: 200,),
            const Text("BienestarMayor", style: TextStyle(fontSize: 26, fontFamily: 'georgia'),),
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
