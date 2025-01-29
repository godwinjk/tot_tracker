// Database Helper Class
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../presentantion/home/model/baby_event.dart';
import '../presentantion/schedule/model/notification_schedule.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('baby_events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String textType = 'TEXT NOT NULL';
    const String intType = 'INTEGER NOT NULL';
    const String realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE baby_events (
        id $idType,
        type $textType,
        eventTime $intType,
        nursingTime $intType,
        quantity $realType,
        info $textType,
        poopColor $textType,
        feedType $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE notification_schedules (
        id $idType,
        title $textType,
        message $textType,
        startTime $intType,
        interval $intType
      )
    ''');
  }

  Future<int> insertBabyEvent(BabyEvent event) async {
    final db = await instance.database;
    return await db.insert('baby_events', event.toMap());
  }

  Future<List<BabyEvent>> getBabyEvents() async {
    final db = await instance.database;
    final result = await db.query('baby_events');

    return result.map((map) => BabyEvent.fromMap(map)).toList();
  }

  Future<BabyEvent?> getBabyEvent(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'baby_events',
      where: 'id = ?',
      whereArgs: [id],
    );
    final events = result.map((map) => BabyEvent.fromMap(map)).toList();
    return events.firstOrNull;
  }

  Future<int> updateBabyEvent(int id, BabyEvent event) async {
    final db = await instance.database;
    return await db.update(
      'baby_events',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteBabyEvent(int id) async {
    final db = await instance.database;
    return await db.delete(
      'baby_events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Schedule

  Future<int> createNotificationSchedule(NotificationSchedule schedule) async {
    final db = await instance.database;
    return await db.insert('notification_schedules', schedule.toMap());
  }

  Future<NotificationSchedule?> getNotificationSchedule(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'notification_schedules',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return NotificationSchedule.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<List<NotificationSchedule>> getAllNotificationSchedules() async {
    final db = await instance.database;
    final result = await db.query('notification_schedules');

    return result.map((map) => NotificationSchedule.fromMap(map)).toList();
  }

  Future<int> updateNotificationSchedule(NotificationSchedule schedule) async {
    final db = await instance.database;
    return await db.update(
      'notification_schedules',
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<int> deleteNotificationSchedule(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notification_schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
