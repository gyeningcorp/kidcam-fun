import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/models/captured_media.dart';

/// SQLite database for indexing captured media metadata.
///
/// Stores lightweight metadata about photos (not the photos themselves).
/// Used for listing, sorting, and managing the photo gallery.
class MediaIndexDb {
  static const _dbName = 'kidcam_media.db';
  static const _tableName = 'media';
  static const _version = 1;

  Database? _db;

  /// Open or create the database.
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(appDir.path, _dbName);

    return openDatabase(
      dbPath,
      version: _version,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            filename TEXT NOT NULL,
            filter_id TEXT NOT NULL,
            captured_at INTEGER NOT NULL,
            file_size_bytes INTEGER NOT NULL
          )
        ''');

        // Index for sorting by capture date
        await db.execute('''
          CREATE INDEX idx_captured_at ON $_tableName (captured_at DESC)
        ''');
      },
    );
  }

  /// Insert a new media record.
  Future<void> insert(CapturedMedia media) async {
    final db = await database;
    await db.insert(
      _tableName,
      media.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get a single media record by ID.
  Future<CapturedMedia?> getById(String id) async {
    final db = await database;
    final results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return CapturedMedia.fromMap(results.first);
  }

  /// List all media records, newest first.
  Future<List<CapturedMedia>> listAll() async {
    final db = await database;
    final results = await db.query(
      _tableName,
      orderBy: 'captured_at DESC',
    );
    return results.map((row) => CapturedMedia.fromMap(row)).toList();
  }

  /// Count total number of stored media records.
  Future<int> count() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as cnt FROM $_tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Delete a single media record.
  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete ALL media records. Parent gate must be verified before calling.
  Future<void> deleteAll() async {
    final db = await database;
    await db.delete(_tableName);
  }

  /// Close the database connection.
  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }
}

/// Riverpod provider for the media index database.
final mediaIndexDbProvider = Provider<MediaIndexDb>((ref) {
  final db = MediaIndexDb();
  ref.onDispose(() => db.close());
  return db;
});
