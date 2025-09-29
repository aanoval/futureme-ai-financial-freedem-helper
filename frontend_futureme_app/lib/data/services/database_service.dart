// SQLite database service for CRUD operations.
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/financial_entry.dart';
import '../models/goal.dart';
import '../models/mood_entry.dart';
import '../../core/utils/logger.dart';

class DatabaseService {
  static Database? _db;
  static const String dbName = 'futureme.db';
  static const int dbVersion = 1;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE financial_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        photoUrl TEXT,
        date TEXT NOT NULL,
        description TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        targetDate TEXT NOT NULL,
        targetAmount REAL NOT NULL,
        currentProgress REAL NOT NULL,
        isAchieved INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE mood_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mood TEXT NOT NULL,
        date TEXT NOT NULL,
        note TEXT,
        aiSuggestion TEXT
      )
    ''');
  }

  // CRUD FinancialEntry
  Future<int> insertFinancial(FinancialEntry entry) async {
    final dbClient = await db;
    return await dbClient.insert('financial_entries', entry.toMap());
  }

  Future<List<FinancialEntry>> getFinancials() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('financial_entries');
    return List.generate(maps.length, (i) => FinancialEntry.fromMap(maps[i]));
  }

  // CRUD Goal
  Future<int> insertGoal(Goal goal) async {
    final dbClient = await db;
    return await dbClient.insert('goals', goal.toMap());
  }

  Future<List<Goal>> getGoals() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('goals');
    return List.generate(maps.length, (i) => Goal.fromMap(maps[i]));
  }

  // CRUD MoodEntry
  Future<int> insertMood(MoodEntry entry) async {
    final dbClient = await db;
    return await dbClient.insert('mood_entries', entry.toMap());
  }

  Future<List<MoodEntry>> getMoodEntries() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('mood_entries');
    return List.generate(maps.length, (i) => MoodEntry.fromMap(maps[i]));
  }
}