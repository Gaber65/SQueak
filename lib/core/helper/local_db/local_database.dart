import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:squeak/features/service/models/reminder_model.dart';

class LocalDatabaseHelper {
  static Database? _database;
  static const String tableName = "reminders";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'reminders.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return _createTable(db);
      },
      onOpen: (db) {
        log("DB is opened");
      },
    );
  }

  static Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reminderType TEXT,
        reminderFreq TEXT,
        date TEXT,
        time TEXT,
        timeAR TEXT,
        notes TEXT,
        otherTitle TEXT,
        petId TEXT,
        notificationID TEXT,
        subTypeFeed TEXT,
        petName TEXT
      )
    ''').then((value) {
      log("created succeefully");
    }).catchError((err) {
      log("error create");
      log(err.toString());
    });
  }

  static Future<int> insertReminder(ReminderModel reminder) async {
    final db = await LocalDatabaseHelper().database;
    return await db.insert(tableName, reminder.toMap());
  }

  static Future<List<ReminderModel>> getAllReminders({required petId}) async {
    final db = await LocalDatabaseHelper().database;
    List<Map<String, dynamic>> result =
        await db.query(tableName, where: 'petId = ?', whereArgs: [petId]);
    return result.map((e) => ReminderModel.fromMap(e)).toList();
  }

  static Future<int> deleteReminder(int id) async {
    final db = await LocalDatabaseHelper().database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> updateReminder(ReminderModel reminder) async {
    final db = await LocalDatabaseHelper._database;
    return await db!.update(tableName, reminder.toMap(),
        where: 'id = ?', whereArgs: [reminder.id]);
  }

  static Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'reminders.db');
    await deleteDatabase(path);
    _database = await initDB();
  }

  static Future<void> recreateDatabase() async {
    final db = await LocalDatabaseHelper().database;
    await db.execute("DROP TABLE IF EXISTS $tableName");
    await _createTable(db);
  }
}
