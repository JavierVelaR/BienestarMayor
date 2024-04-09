import 'dart:ui';

import 'package:bienestar_mayor/theme/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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
      appBar: AppBar(
        title: const Text("BienestarMayor", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),),
        centerTitle: true,
        backgroundColor: CustomColors.verdeBosque,
        toolbarHeight: 70,
        shadowColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white, size: 55,), onPressed: (){ _showMenu(); },),
        actions: [
          IconButton(onPressed: () { _showAccount();}, icon: const Icon(Icons.person), iconSize: 50, color: Colors.white,),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(
                    width: 140,
                    child: Text("Gestionar medicamentos", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.blueAccent),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: _cardOnTap,
                      child: const Text("Medicamentos", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 25,),
              Column(
                children: [
                  const SizedBox(
                    width: 140,
                    child: Text("Llamar a emergencias", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))
                ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.red),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: _cardOnTap,
                      child: const Text("Emergencia", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text("Holaa"),
        ],
      ),
    );
  }

  //////////////////////////////////
  // ELEMENTOS
  //////////////////////////////////
  
  _card(String text, Color color){
    return Card(
      margin: const EdgeInsets.all(10),
      color: color,
        child: Text(text),
    );
  }
  
  
  ////////////////////////////////////////////
  // ACCIONES
  ////////////////////////////////////////////

  _cardOnTap(){

  }

  _showMenu(){
    debugPrint("Se ha pulsado el icono del menu");
  }

  _showAccount(){
    debugPrint("Se ha pulsado el icono de la cuenta");
  }

}
