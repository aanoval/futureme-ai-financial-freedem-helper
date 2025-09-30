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

  // Singleton-like database access
  Future<Database> get db async {
    if (_db != null && _db!.isOpen) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // Initialize database
  Future<Database> _initDb() async {
    try {
      String path = join(await getDatabasesPath(), dbName);
      final database = await openDatabase(
        path,
        version: dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
      logInfo('Database initialized at $path');
      return database;
    } catch (e, stackTrace) {
      logError('Error initializing database', e);
      rethrow;
    }
  }

  // Create database tables
  Future<void> _onCreate(Database db, int version) async {
    try {
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
      logInfo('Database tables created successfully');
    } catch (e, stackTrace) {
      logError('Error creating tables', e);
      rethrow;
    }
  }

  // Handle database upgrades (for future schema changes)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    logInfo('Upgrading database from version $oldVersion to $newVersion');
    // Add migration logic here if needed
  }

  // Close database
  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
      _db = null;
      logInfo('Database closed');
    }
  }

  // CRUD FinancialEntry
  Future<int> insertFinancial(FinancialEntry entry) async {
    try {
      final dbClient = await db;
      final result = await dbClient.insert('financial_entries', entry.toMap());
      logInfo('Inserted financial entry: ${entry.toMap()}');
      return result;
    } catch (e, stackTrace) {
      logError('Error inserting financial entry', e);
      rethrow;
    }
  }

  Future<List<FinancialEntry>> getFinancials() async {
    try {
      final dbClient = await db;
      final List<Map<String, dynamic>> maps = await dbClient.query('financial_entries');
      final entries = List.generate(maps.length, (i) => FinancialEntry.fromMap(maps[i]));
      logInfo('Retrieved ${entries.length} financial entries');
      return entries;
    } catch (e, stackTrace) {
      logError('Error retrieving financial entries', e);
      return [];
    }
  }

  Future<int> deleteFinancial(int id) async {
    try {
      final dbClient = await db;
      final result = await dbClient.delete(
        'financial_entries',
        where: 'id = ?',
        whereArgs: [id],
      );
      logInfo('Deleted financial entry with id $id');
      return result;
    } catch (e, stackTrace) {
      logError('Error deleting financial entry', e);
      rethrow;
    }
  }

  // CRUD Goal
  Future<int> insertGoal(Goal goal) async {
    try {
      final dbClient = await db;
      final result = await dbClient.insert('goals', goal.toMap());
      logInfo('Inserted goal: ${goal.toMap()}');
      return result;
    } catch (e, stackTrace) {
      logError('Error inserting goal', e);
      rethrow;
    }
  }

  Future<List<Goal>> getGoals() async {
    try {
      final dbClient = await db;
      final List<Map<String, dynamic>> maps = await dbClient.query('goals');
      final goals = List.generate(maps.length, (i) => Goal.fromMap(maps[i]));
      logInfo('Retrieved ${goals.length} goals');
      return goals;
    } catch (e, stackTrace) {
      logError('Error retrieving goals', e);
      return [];
    }
  }

  Future<void> updateGoalProgress(int id, double progress) async {
    try {
      final dbClient = await db;
      await dbClient.update(
        'goals',
        {
          'currentProgress': progress.clamp(0.0, 1.0),
          'isAchieved': progress >= 1.0 ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      logInfo('Updated goal progress for id $id to $progress');
    } catch (e, stackTrace) {
      logError('Error updating goal progress', e);
      rethrow;
    }
  }

  Future<int> deleteGoal(int id) async {
    try {
      final dbClient = await db;
      final result = await dbClient.delete(
        'goals',
        where: 'id = ?',
        whereArgs: [id],
      );
      logInfo('Deleted goal with id $id');
      return result;
    } catch (e, stackTrace) {
      logError('Error deleting goal', e);
      rethrow;
    }
  }

  // CRUD MoodEntry
  Future<int> insertMood(MoodEntry entry) async {
    try {
      final dbClient = await db;
      final result = await dbClient.insert('mood_entries', entry.toMap());
      logInfo('Inserted mood entry: ${entry.toMap()}');
      return result;
    } catch (e, stackTrace) {
      logError('Error inserting mood entry', e);
      rethrow;
    }
  }

  Future<List<MoodEntry>> getMoodEntries() async {
    try {
      final dbClient = await db;
      final List<Map<String, dynamic>> maps = await dbClient.query('mood_entries');
      final entries = List.generate(maps.length, (i) => MoodEntry.fromMap(maps[i]));
      logInfo('Retrieved ${entries.length} mood entries');
      return entries;
    } catch (e, stackTrace) {
      logError('Error retrieving mood entries', e);
      return [];
    }
  }

  Future<int> deleteMoodEntry(int id) async {
    try {
      final dbClient = await db;
      final result = await dbClient.delete(
        'mood_entries',
        where: 'id = ?',
        whereArgs: [id],
      );
      logInfo('Deleted mood entry with id $id');
      return result;
    } catch (e, stackTrace) {
      logError('Error deleting mood entry', e);
      rethrow;
    }
  }
}