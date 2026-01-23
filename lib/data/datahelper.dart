import 'package:projetfinal/models/note.dart';
import 'package:projetfinal/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  static const String tableNotes = 'notes';
  static const String tableUsers = 'users';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
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
    await db.execute('''
      CREATE TABLE $tableNotes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

  }

  // Insérer un utilisateur
  Future<int> insertUser(User user) async {
    final db = await instance.database;
    try {
      return await db.insert(tableUsers, user.toMap());
    } catch (e) {
      throw Exception('Erreur lors de l\'insertion de l\'utilisateur : $e');
    }
  }

  // S'authentifier 
  Future<User?> authenticateUser(String emailOrUsername, String password) async {
    final db = await instance.database;

    final results = await db.query(
      tableUsers,
      where: '(email = ? OR username = ?) AND password = ?',
      whereArgs: [emailOrUsername, emailOrUsername, password],
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first); 
    }
    return null; 
  }

  // Obtenir tous les utilisateurs 
  Future<List<User>> fetchAllUsers() async {
    final db = await instance.database;
    final results = await db.query(tableUsers);

    return results.map((json) => User.fromMap(json)).toList();
  }

  // Ajouter une nouvelle note
  Future<int> insertNote(Note note, String text) async {
    final db = await instance.database;
    return await db.insert(tableNotes, note.toMap());
  }

  // Lire toutes les notes
  Future<List<Note>> fetchNotes() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query(tableNotes);

    return result.map((json) => Note.fromMap(json)).toList();
  }

  // Mettre à jour une note
  Future<int> updateNote(Note note) async {
    final db = await instance.database;

    return await db.update(
      tableNotes,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Supprimer une note
  Future<int> deleteNote(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await _database;
    db?.close();
  }
}