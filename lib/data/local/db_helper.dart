import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  /// singleton
  DbHelper._();
  static final DbHelper getInstances = DbHelper._();

  ///table note
  static final TABLE_NOTE = "note";
  static final COLUMN_NOTE_SNO = "s_no";
  static final COLUMN_NOTE_TITLE = "title";
  static final COLUMN_NOTE_DESC = "desc";
  Database? myDB;

  /// db open(path -> if exist then open else create db)
  Future<Database?> getDb() async {
    myDB = myDB ?? await openDb();
    return myDB;
    // if (myDB != null) {
    //   return myDB!;
    // } else {
    //   myDB = await openDb();
    //   return myDB!;
    // }
  }

  Future<Database> openDb() async {
    Directory dirApp = await getApplicationCacheDirectory();
    String dbPath = join(dirApp.path, "noteDB");
    return await openDatabase(dbPath, onCreate: (db, version) {
      /// Create your table here
      db.execute(
          "create table $TABLE_NOTE($COLUMN_NOTE_SNO integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text)");

      //
      //
      //
    }, version: 1);
  }

  /// add query
  /// insertion
  Future<bool> addNote({required String mTitle, required String mDesc}) async {
    var db = await getDb();
    int? rowEffected = await db?.insert(
        TABLE_NOTE, {COLUMN_NOTE_TITLE: mTitle, COLUMN_NOTE_DESC: mDesc});
    return (rowEffected ?? 0) > 0;
  }

  /// Reading all data
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDb();

    ///select * from notes
    List<Map<String, dynamic>> mData = await db!.query(TABLE_NOTE);
    return mData;
  }

  ///Update Data
  Future<bool> update(
      {required String mTitle, required String mDesc, required int sNo}) async {
    var db = await getDb();
    int? rowEFFected = await db?.update(
        TABLE_NOTE, {COLUMN_NOTE_TITLE: mTitle, COLUMN_NOTE_DESC: mDesc},
        where: "$COLUMN_NOTE_SNO=?", whereArgs: [sNo]);

    return (rowEFFected ?? 0) > 0;
  }

  ///Delete Data
  Future<bool> deleteData({required int sNo}) async {
    var db = await getDb();
    int? rowEffected = await db
        ?.delete(TABLE_NOTE, where: "$COLUMN_NOTE_SNO=?", whereArgs: [sNo]);
    return (rowEffected ?? 0) > 0;
  }
}
