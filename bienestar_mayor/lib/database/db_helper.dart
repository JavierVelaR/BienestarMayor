import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  static DbHelper? _dbHelper;

  DbHelper._internal();

  static DbHelper get instance => _dbHelper ??= DbHelper._internal();

  Database? _db;

  Database get db => _db!;

  final String createMedicamentosQuery =
      'CREATE TABLE medicamentos('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
      'nombre TEXT, '
      'dosis TEXT,'
      'frecuencia INTEGER,'
      'duracion INTEGER,'
      'foto TEXT)';

  final String createRecordatoriosQuery =
      'CREATE TABLE recordatorios('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
      'id_medicamento INTEGER, '
      'hora TEXT,'
      'FOREIGN KEY (id_medicamento) REFERENCES medicamentos(id))';

  final String createHistorialQuery =
      'CREATE TABLE historial('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
      'id_recordatorio INTEGER, '
      'tomado BOOLEAN,'
      'FOREIGN KEY (id_recordatorio) REFERENCES recordatorios(id))';

  final String createEventosQuery =
      'CREATE TABLE eventos('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
      'titulo TEXT, '
      'descripcion TEXT,'
      'fecha TEXT)';

  init() async{
    // deleteDatabase(join( await getDatabasesPath(), 'BienestarMayor_database.db'));

    _db = await openDatabase(join(await getDatabasesPath(), 'BienestarMayor_database.db'),
      onConfigure: (db) async{
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async{
        await db.execute(createMedicamentosQuery);
        await db.execute(createRecordatoriosQuery);
        await db.execute(createHistorialQuery);
        await db.execute(createEventosQuery);
      },
      version: 1,
    );

    debugPrint("---------> PATH: ${_db?.path}");
    // debugPrint("---------> PATH: ${getDatabasePath("mybasededatos.db").getAbsolutePath()}");
  }

}