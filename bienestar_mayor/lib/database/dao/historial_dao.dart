import 'package:bienestar_mayor/model/historial.dart';
import 'package:sqflite/sqflite.dart';

import '../db_helper.dart';

class HistorialDao{
  final database = DbHelper().db;
  final tableName = 'historial';

  Future<List<Historial>> readAllHistoriales() async{
    final data = await database.query(tableName);
    return data.map((e) => Historial.fromMap(e)).toList();
  }

  Future<int> insertHistorial(Historial historial) async {
    return await database.insert(tableName, historial.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  Future<void> updateHistorial(Historial historial) async{
    await database.update(tableName, historial.toMap(), where: 'id = ?', whereArgs: [historial.id]);
  }

  Future<void> deleteHistorial(Historial historial) async{
    await database.delete(tableName, where: 'id = ?', whereArgs: [historial.id]);
  }


}