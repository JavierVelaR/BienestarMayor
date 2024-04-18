import 'package:bienestar_mayor/model/medicamento.dart';
import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';

class ScreenAddMedicamento extends StatefulWidget {
  const ScreenAddMedicamento({super.key});

  @override
  State<ScreenAddMedicamento> createState() => _ScreenAddMedicamentoState();
}

class _ScreenAddMedicamentoState extends State<ScreenAddMedicamento> {
  final _nameController = TextEditingController();
  final _dosisController = TextEditingController();
  String _tipoDosis = "";
  int _horasEntreToma = -1;
  DateTimeRange _selectedDayRange = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7)));

  /// TODO: formulario para añarir medicacion
  /// Que haya un dropdown para seleccionar mg (miligramos) , ml (mililitros), etc...
  /// Que haya también opción de no hay dosis, para tratamientos por ejemplo de quimio, radiografía...
  /// Que haya un dropdown para seleccionar día, semana, mes, etc...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              const Text("Nombre del medicamento:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
              _editName(),
              const Text("Cantidad de dosis:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
              const SizedBox(height: 8,),
              _editDosis(),
              const SizedBox(height: 20,),
              const Text("Cada cuantas horas:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
              _radioButtonsFrequency(),
              const SizedBox(height: 20,),
              const Text("Duración del tratamiento:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
              const SizedBox(height: 15,),
              Text("Inicio: ${_toDate(_selectedDayRange.start.day, _selectedDayRange.start.month)}     "
                  "Fin: ${_toDate(_selectedDayRange.end.day, _selectedDayRange.end.month)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CustomColors.zafiro),
              ),
              const SizedBox(height: 10,),
              _editDuration(),
              const SizedBox(height: 20,),
              _addPhoto(),
              const SizedBox(height: 30,),
              _buttons(),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: const Text(
        "Añadir medicamento",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      backgroundColor: CustomColors.azulFrancia,
      toolbarHeight: 70,
      shadowColor: Colors.black,
      // leading: IconButton(icon: const Icon(Icons.menu, color: Colors.white, size: 55,), onPressed: (){ _showMenu(); },),
    );
  }

  ////////////////////////////////// ELEMENTOS FORMULARIO ////////////////////////////////////////
  _editName() => TextField(
    controller: _nameController,
    decoration: const InputDecoration(
      hintText: "Introduce el nombre",
      hintStyle: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
      suffixIcon: Icon(Icons.edit),
    ),
    style: const TextStyle(fontSize: 20),
    autocorrect: false,
    maxLength: 30,
  );

  _editDosis() => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width/2.2,
        child: TextField(
          controller: _dosisController,
          decoration: const InputDecoration(
            filled: true,
            hintText: "Introducir",
            hintStyle: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          ),
          keyboardType:  const TextInputType.numberWithOptions(decimal: false, signed: true),
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(width: 20,),
      DropdownMenu(
        dropdownMenuEntries: const [
          DropdownMenuEntry(value: 'mg', label: 'miligramos'),
          DropdownMenuEntry(value: 'ml', label: 'mililitros'),
        ],
        onSelected: (value){ value!=null ? _tipoDosis = value : _tipoDosis = ""; },
      )
    ],
  );

  _radioButtonsFrequency(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
            value: 4,
            groupValue: _horasEntreToma,
            onChanged: (value){
              setState(() {
                _horasEntreToma = value!;
              });
            }),
        const Text("4 h"),
        const SizedBox(width: 20,),
        Radio(
            value: 6,
            groupValue: _horasEntreToma,
            onChanged: (value){
              setState(() {
                _horasEntreToma = value!;
              });
            }),
        const Text("6 h"),
        const SizedBox(width: 20,),
        Radio(
            value: 8,
            groupValue: _horasEntreToma,
            onChanged: (value){
              setState(() {
                _horasEntreToma = value!;
              });
            }),
        const Text("8 h"),
        const SizedBox(width: 20,),
        Radio(
            value: 12,
            groupValue: _horasEntreToma,
            onChanged: (value){
              setState(() {
                _horasEntreToma = value!;
              });
            }),
        const Text("12 h"),

      ],
    );
  }

  _editDuration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () async{
              setState(() {
                _selectedDayRange = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7)));
              });
            },
            child: const Text("7 días"),),
        ),

        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () async{
              setState(() {
                _selectedDayRange = DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 14)));
              });
            },
            child: const Text("14 días"),),
        ),

        SizedBox(
          width: 130,
          child: ElevatedButton(
            onPressed: () async{
              var selectedRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),

              );
              setState(() {
                if(selectedRange!=null) _selectedDayRange = selectedRange;
              });
            },

            child: const Text("  Indicar\nDuración"),),
        ),
      ],
    );
  }

  _buttons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 60,
          child: FilledButton(
              onPressed: (){ Navigator.of(context).pop(); },
              child: const Text("Cancelar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),)
          ),
        ),
        const SizedBox(width: 25,),
        SizedBox(
          width: 150,
          height: 60,
          child: FilledButton(
              onPressed: (){
                if(_guardarMedicamento()) {
                  Navigator.of(context).pop();
                }else{
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Error al guardar", style: TextStyle(fontSize: 28),),
                          contentPadding: const EdgeInsets.all(25),
                          content: const Text("Tienes que rellenar todos los campos", style: TextStyle(fontSize: 18),),
                          actions: [
                            TextButton(
                                onPressed: (){ Navigator.pop(context); }, 
                                child: const Text("Vale", style: TextStyle(fontSize: 20),)
                            ),
                          ],
                        );
                      }
                  );
                }
              },
              child: const Text("Guardar", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),)
          ),
        ),
      ],
    );
  }

  _addPhoto(){
    bool fotoCogida = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
            width: 220,
            height: 30,
            child: Text("Puedes añadir foto:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),)
        ),
        ElevatedButton(
            onPressed: (){
              //TODO: código para añadir foto
              // fotoCogida = true;
            },
            child: fotoCogida ? const Icon(Icons.verified, size: 30, color: CustomColors.verdeLima,)
                : const Text("Añadir foto", style: TextStyle(fontSize: 16))),
      ],
    );
  }

  ///////////////// CONVERSOR DE NUMEROS A PALABRA ////////////////////
  String _toDate(int day, int monthNumber) {
    Map<int, String> months = {
      1: "enero",
      2: "febrero",
      3: "marzo",
      4: "abril",
      5: "mayo",
      6: "junio",
      7: "julio",
      8: "agosto",
      9: "septiembre",
      10: "octubre",
      11: "noviembre",
      12: "diciembre"
    };

    String month = months[monthNumber] ?? "Mes inválido";
    return "$day de $month";
  }


  /////////////////// GUARDAR EN BASE DE DATOS ////////////////////////
  ///TODO: insertar medicamento a db
  ///devuelve true si se ha insertado correctamente
  bool _guardarMedicamento(){
    String nombre = _nameController.text;
    String dosis = _dosisController.text;
    String tipoDosis = _tipoDosis;
    String dosisText = "$dosis $tipoDosis";
    int horasEntreToma = _horasEntreToma;
    int duracion = _selectedDayRange.duration.inDays;


    if(nombre.isEmpty || dosis.isEmpty || tipoDosis.isEmpty || horasEntreToma == -1){
      return false;
    }
    debugPrint("Nombre: $nombre, dosis: $dosisText, horas entre cada toma: $horasEntreToma, duración: $duracion días}");

    final newMedicamento = Medicamento(nombre: nombre, dosis: dosisText, duracion: duracion);

    /// Insertar medicamento en db


    ///TODO: Una vez insertado el medicamento en la db, añadir los recordatorios a la db, y programar las alarmas


    return true;
  }

}
