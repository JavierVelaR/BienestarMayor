import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../generated/assets.dart';
import '../router.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  static const DURATION_SPLASH = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

    Future.delayed(DURATION_SPLASH).then((value) async{
      Navigator.pushNamedAndRemoveUntil(context, ROUTE_PRINCIPAL, (route) => false,);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeith = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80,),
            SvgPicture.asset(Assets.imagesBienestarMayorLogo, width: mediaWidth, height: mediaHeith, fit: BoxFit.cover),
            const Text("BienestarMayor", style: TextStyle(fontSize: 46, fontFamily: 'georgia'),)
          ],
        )
      ),
    );
  }

}