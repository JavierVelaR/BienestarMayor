import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';
import '../../widgets/drawer_custom.dart';

class ScreenMedicamentoDetails extends StatefulWidget {
  const ScreenMedicamentoDetails({super.key});

  @override
  State<ScreenMedicamentoDetails> createState() => _ScreenMedicamentoDetailsState();
}

class _ScreenMedicamentoDetailsState extends State<ScreenMedicamentoDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles", style: TextStyle(fontSize: 26)),
        centerTitle: true,
        backgroundColor: CustomColors.azulFrancia,
        toolbarHeight: 70,
        shadowColor: Colors.black,
        ),

      /// TODO: boton para borrar medicamento
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FittedBox(
          child: FloatingActionButton(
              foregroundColor: CustomColors.rojoLadrillo,
              backgroundColor: CustomColors.salmonClaro,

              child: const Icon(Icons.delete, size: 35,),
              onPressed: () {}
          ),
        ),
      ),

      body: Container(
          padding: const EdgeInsets.all(8),
          child: const Column(
            children: [
              Text("Nombre: @nombre", style: TextStyle(fontSize: 20,),),
              Text("Dosis: @dosis", style: TextStyle(fontSize: 20,),),
              Text("Frecuencia: @veces cada @frecuencia", style: TextStyle(fontSize: 20,),),

            ],
          )),
    );
  }
}
