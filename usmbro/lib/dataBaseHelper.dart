import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:usmbro/post_users.dart';
import 'package:usmbro/user.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // Si la base de données n'a pas été créée, initialisez-la.
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Code pour créer la table si elle n'existe pas.
        db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            nom TEXT,
            prenom TEXT,
            filiere TEXT, 
            token TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertUser(User user) async {
    final Database db = await database;

    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
