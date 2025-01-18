import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Reservation.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'reservations.db');
      print('Database path: $path'); // Debugging

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      print('Error initializing database: $e'); // Debugging
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE reservations(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          date TEXT,
          time TEXT,
          field TEXT
        )
      ''');
      print('Table created successfully'); // Debugging
    } catch (e) {
      print('Error creating table: $e'); // Debugging
    }
  }

  Future<int> insertReservation(Reservation reservation) async {
    try {
      final db = await database;
      final id = await db.insert('reservations', reservation.toMap());
      print('Reservation inserted with ID: $id'); // Debugging
      return id;
    } catch (e) {
      print('Error inserting reservation: $e'); // Debugging
      rethrow;
    }
  }

  Future<List<Reservation>> getReservations() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('reservations');
      print('Reservations fetched: $maps'); // Debugging
      return List.generate(maps.length, (i) {
        return Reservation.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error fetching reservations: $e'); // Debugging
      rethrow;
    }
  }

  Future<void> deleteReservation(int id) async {
    try {
      final db = await database;
      await db.delete(
        'reservations',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Reservation deleted with ID: $id'); // Debugging
    } catch (e) {
      print('Error deleting reservation: $e'); // Debugging
      rethrow;
    }
  }
}
