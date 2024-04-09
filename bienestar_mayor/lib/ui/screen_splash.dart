import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../control/manager_user.dart';
import '../generated/assets.dart';
import '../router.dart';

class ScreenSplash extends StatefulWidget{
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash>{
  static const DURATION_SPLASH = Duration(seconds: 2);

  @override
  void initState(){
    super.initState();

    Future.delayed(DURATION_SPLASH).then((value) async{
      _checkUserLogged();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.loose,
        children: [
          _showLogo(),
        ],
      )
    );
  }

  _showLogo() => Center(
    child: Column(
      children: [
        // const SizedBox(height: 150),
        SvgPicture.asset(Assets.imagesPlaceholderLogo),
        const SizedBox(height: 30,),
        const Text(
          "Cargando sesión...",
          style:
          TextStyle(fontSize: 24, color: CupertinoColors.inactiveGray),
        )
      ],
    ),
  );

  _checkUserLogged() async {
    if(await ManagerUser().thereIsSessionSaved()) {
      // Si existe sesion, descargar datos del usuario y volverlo a loguear
      final userSession = await ManagerUser().getSessionFromPrefs();
      _apiLogin(userSession[ManagerUser.PREFS_USER_EMAIL]!, userSession[ManagerUser.PREFS_USER_PASS]!);

    } else{
      // No hay sesion guardada, enviar al usuario a loguearse
      /// CAMBIAR A ROUTE_LOGIN
      // Navigator.pushNamed(context, ROUTE_LOGIN);
      Navigator.pushNamedAndRemoveUntil(context, ROUTE_PRINCIPAL, (route) => false,);
    }
  }

  _apiLogin(String email, String password) {
    // UserApi.login(email, password).then((ResponseLogin responseLogin) async {
    //   debugPrint("----------------LOGIN> ${responseLogin.message}");
    //
    //   await ManagerUser().saveSessionToPrefs(email, password, responseLogin);
    //
    //   if (mounted) {
    //     Navigator.pushNamedAndRemoveUntil(context, ROUTE_PRINCIPAL, (route) => false);
    //   }
    // });
  }
}