import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'currency.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rates (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        base_currency TEXT NOT NULL,
        currency_code TEXT NOT NULL,
        rate REAL NOT NULL,
        timestamp INTEGER NOT NULL,
        UNIQUE(base_currency, currency_code)
      )
    ''');
  }

  Future<void> cacheRates(String baseCurrency, Map<String, dynamic> rates) async {
    final db = await database;
    final batch = db.batch();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    rates.forEach((code, rate) {
      batch.insert(
        'rates',
        {
          'base_currency': baseCurrency,
          'currency_code': code,
          'rate': rate,
          'timestamp': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit(noResult: true);
  }

  Future<Map<String, dynamic>?> getCachedRates(String baseCurrency) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'rates',
      where: 'base_currency = ?',
      whereArgs: [baseCurrency],
    );

    if (maps.isNotEmpty) {
      final Map<String, dynamic> rates = {};
      int? timestamp;
      for (var map in maps) {
        rates[map['currency_code']] = map['rate'];
        timestamp ??= map['timestamp']; // Get timestamp from the first row
      }
      return {
        'rates': rates,
        'timestamp': timestamp,
      };
    }
    return null;
  }
}
