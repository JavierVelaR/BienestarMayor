import 'package:bienestar_mayor/model/recordatorio.dart';
import 'package:sqflite/sqflite.dart';

import '../db_helper.dart';

class RecordatorioDao{
  final database = DbHelper().db;
  final tableName = 'recordatorios';

  Future<List<Recordatorio>> readAllRecordatorios() async{
    final data = await database.query(tableName);
    return data.map((e) => Recordatorio.fromMap(e)).toList();
  }

  Future<int> insertRecordatorio(Recordatorio recordatorio) async {
    return await database.insert(tableName, recordatorio.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  Future<void> updateRecordatorio(Recordatorio recordatorio) async{
    await database.update(tableName, recordatorio.toMap(), where: 'id = ?', whereArgs: [recordatorio.id]);
  }

  Future<void> deleteRecordatorio(Recordatorio recordatorio) async{
    await database.delete(tableName, where: 'id = ?', whereArgs: [recordatorio.id]);
  }


}