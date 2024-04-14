import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../generated/assets.dart';
import '../../theme/custom_colors.dart';

class ScreenConfigUser extends StatefulWidget {
  const ScreenConfigUser({super.key});

  @override
  State<ScreenConfigUser> createState() => _ScreenConfigUserState();
}

class _ScreenConfigUserState extends State<ScreenConfigUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 180,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Assets.imagesEyeClosed, width: 50,),
                    const SizedBox(height: 20,),
                    const Text('Nombre usuario', style: TextStyle(fontSize: 18),),
                    const Text('email@email.com', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),

              // Boton editar
              Container(
                  width: 150,
                  height: 100,
                  alignment: Alignment.center,
                  // padding: const EdgeInsets.all(10),

                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                    ),
                    onPressed: () { _onEditClick(); },
                    child: const Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 18, height: 75,),
                          Text('Editar'),
                        ],
                      ),
                  ),
                ),

            ],
          ),

        ],
      ),
    );
  }
}

_appBar(){
  return AppBar(
    title: const Text("Configuración", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),),
    centerTitle: true,
    backgroundColor: CustomColors.verdeBosque,
    toolbarHeight: 70,
    shadowColor: Colors.black,
    // leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white, size: 55,), onPressed: (){ _showMenu(); },),
  );
}

_onEditClick(){

}
