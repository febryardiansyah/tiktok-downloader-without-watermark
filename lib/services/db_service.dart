import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tiktok_downloader/models/tiktok_validation_model.dart';

class DbService {
  String _historyTable = 'history';

  Future<Database> _initializeDb() async {
    if (kDebugMode) {
      await Sqflite.setDebugModeOn();
    }
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'first.db'),
      onCreate: (db, version) async {
        final batch = db.batch();
        batch.execute("CREATE TABLE $_historyTable (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT NOT NULL, title TEXT NOT NULL, author_url TEXT NOT NULL, author_name TEXT NOT NULL, thumbnail_url TEXT NOT NULL, video_url TEXT NOT NULL, created_at DATETIME NOT NULL)");
        batch.commit();
      },
      version: 1,
    );
  }

  Future<String> saveVideo(TiktokValidationModel video) async {
    print('DATA SAVED: ${video.toSqlite()}');
    try {
      final db = await _initializeDb();
      await db.insert(_historyTable, video.toSqlite());
      return 'Video has been saved';
    }on DatabaseException catch (e) {
      print('SAVE VIDEO ERR: ${e.result}');
      throw e.result ?? 'Failure';
    }
  }

  Future<List<TiktokValidationModel>> getSavedVideo() async {
    try {
      final db = await _initializeDb();
      final res = await db.query(_historyTable, orderBy: 'created_at DESC');
      print(res);

      return List<TiktokValidationModel>.from((res).map((e) => TiktokValidationModel.fromSqlite(e)));
    } on DatabaseException catch (e) {
      print('GET VIDEOS ERR: ${e.result}');
      throw e.result ?? 'Failure';
    }
  }
}
