import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/restaurant.dart';

/// SQLite database helper for local data storage
class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  static const String _tableFavorites = 'favorites';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'nyamnyam.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableFavorites (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        pictureId TEXT NOT NULL,
        city TEXT NOT NULL,
        rating REAL NOT NULL
      )
    ''');
  }

  /// Add restaurant to favorites
  Future<void> addFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(_tableFavorites, {
      'id': restaurant.id,
      'name': restaurant.name,
      'description': restaurant.description,
      'pictureId': restaurant.pictureId,
      'city': restaurant.city,
      'rating': restaurant.rating,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Remove restaurant from favorites
  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableFavorites, where: 'id = ?', whereArgs: [id]);
  }

  /// Get all favorite restaurants
  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableFavorites);

    return List.generate(maps.length, (i) {
      return Restaurant(
        id: maps[i]['id'] as String,
        name: maps[i]['name'] as String,
        description: maps[i]['description'] as String,
        pictureId: maps[i]['pictureId'] as String,
        city: maps[i]['city'] as String,
        rating: maps[i]['rating'] as double,
      );
    });
  }

  /// Check if restaurant is in favorites
  Future<bool> isFavorite(String id) async {
    final db = await database;
    final result = await db.query(
      _tableFavorites,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}
