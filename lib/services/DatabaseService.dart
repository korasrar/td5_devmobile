import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:td2/models/task.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;
  static late SupabaseClient _supabase;

  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      await Supabase.initialize(
        url: 'url here',
        anonKey: 'anon key here',
      );
    } catch (e) {
      // ruuh
    }

    _supabase = Supabase.instance.client;

    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    final path = join(await getDatabasesPath(), 'task_database.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, nbhours INTEGER, difficulty INTEGER, tags TEXT, isExported INTEGER DEFAULT 0)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE tasks ADD COLUMN isExported INTEGER DEFAULT 0');
        }
      },
    );
  }

  Future<List<Task>> getTasksFromSupabase() async {
    try {
      final response = await _supabase.from('tasks').select();
      return (response as List).map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching from Supabase: $e');
      return [];
    }
  }

  Future<void> insertTask(Task task) async {
    final db = await database;

    if (task.isExported) {
      try {
        final data = task.toJson();
        final response = await _supabase.from('tasks').insert(data).select().single();
        task.id = response['id'];
      } catch (e) {
        debugPrint('Error exporting to Supabase: $e');
        task.isExported = false;
      }
    }

    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;

    final supabaseTasks = await getTasksFromSupabase();
    for (var task in supabaseTasks) {
      await db.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<void> updateTask(Task updatedTask) async {
    final db = await database;

    if (updatedTask.isExported) {
      try {
        await _supabase.from('tasks').upsert(updatedTask.toJson());
      } catch (e) {
        debugPrint('Error updating Supabase: $e');
      }
    }

    await db.update(
      'tasks',
      updatedTask.toMap(),
      where: 'id = ?',
      whereArgs: [updatedTask.id],
    );
  }

  Future<void> deleteTask(Task task) async {
    final db = await database;

    if (task.isExported && task.id != null) {
      try {
        await _supabase.from('tasks').delete().eq('id', task.id!);
      } catch (e) {
        debugPrint('Error deleting from Supabase: $e');
      }
    }

    await db.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }
}