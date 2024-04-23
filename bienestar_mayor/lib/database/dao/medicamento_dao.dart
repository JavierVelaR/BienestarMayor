import 'package:bienestar_mayor/model/medicamento.dart';
import 'package:sqflite/sqflite.dart';

import '../db_helper.dart';

class MedicamentoDao{
  final database = DbHelper.instance.db;
  final tableName = 'medicamentos';

  Future<List<Medicamento>> readAllMedicamentos() async{
    final data = await database.query(tableName);
    return data.map((e) => Medicamento.fromMap(e)).toList();
  }

  Future<int> insertMedicamento(Medicamento medicamento) async {
    return await database.insert(tableName, medicamento.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  Future<void> updateMedicamento(Medicamento medicamento) async{
    await database.update(tableName, medicamento.toMap(), where: 'id = ?', whereArgs: [medicamento.id]);
  }

  Future<void> deleteMedicamento(Medicamento medicamento) async{
    await database.delete(tableName, where: 'id = ?', whereArgs: [medicamento.id]);
  }


}