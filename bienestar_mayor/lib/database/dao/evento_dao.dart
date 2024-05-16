import 'package:bienestar_mayor/model/evento.dart';
import 'package:sqflite/sqflite.dart';

import '../db_helper.dart';

class EventoDao{
  final database = DbHelper().db;
  final tableName = 'eventos';

  Future<List<Evento>> readAlEventos() async{
    final data = await database.query(tableName);
    return data.map((e) => Evento.fromMap(e)).toList();
  }

  Future<int> insertEvento(Evento evento) async {
    return await database.insert(tableName, evento.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
  }

  Future<void> updateEvento(Evento evento) async{
    await database.update(tableName, evento.toMap(), where: 'id = ?', whereArgs: [evento.id]);
  }

  Future<void> deleteEvento(Evento evento) async{
    await database.delete(tableName, where: 'id = ?', whereArgs: [evento.id]);
  }


}