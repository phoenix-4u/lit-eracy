import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants.dart';

class LocalDatabase {
  static Database? _instance;

  static Future<Database> getInstance() async {
    if (_instance != null) return _instance!;
    final path = await getDatabasesPath();
    final dbPath = join(path, AppConstants.dbName);
    _instance = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE progress (
            id INTEGER PRIMARY KEY,
            userId INTEGER,
            lessonId INTEGER,
            completedAt TEXT
          )
        ''');
      },
    );
    return _instance!;
  }
}
