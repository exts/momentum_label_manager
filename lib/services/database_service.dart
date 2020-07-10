import 'package:momentum_label_manager/constants/database.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// our singleton db service class that we'll be using within our repository
/// this doesn't respect SOLID fully because we are hard coupling this to our
/// repository, but that's fine because we aren't replacing this with another db
/// lol and it's just an example ;)
class DatabaseService {
  int count = 0;

  static DatabaseService get singleton =>
      (_instance = _instance ?? DatabaseService._private());
  static DatabaseService _instance;
  static Future<Database> get db => singleton.connect();

  Database _db;
  DatabaseService._private();

  Future<Database> connect() async {
    if (_db != null) return _db;

    var path = await getDatabasesPath();
    path = join(path, kDatabaseFilename);
    _db = await openDatabase(path, version: 1, onCreate: _createTables);

    return _db;
  }

  Future<void> _createTables(Database db, version) async {
    for (var query in kDatabaseTablesCreateList) {
      await db.execute(query);
    }
  }
}
