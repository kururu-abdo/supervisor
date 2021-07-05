import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
    import 'dart:io' as io;

import 'package:app3/model/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "notifications.db");
    return await openDatabase(path, version: 3, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Notification ("
          "id INTEGER PRIMARY KEY  AUTOINCREMENT ,"
          "time INTEGER  ,"
          "title  TEXT,"
          "body  TEXT,"
          "object TEXT ,"
          "isread BIT ) ");
    });
  }

  Future<int> newNotification(LocalNotification notification) async {
    final db = await database;
    //get the biggest id in the table

    var raw = await db.rawInsert(
        "INSERT Into Notification (time,title  ,  body ,object ,isread)"
        " VALUES (?,?,?,? ,?)",
        [
          DateTime.now().millisecondsSinceEpoch,
          notification.title,
          notification.body,
          notification.object,
          false
        ]);
    return raw;
  }

  updateNotifica(LocalNotification notification) async {
    final db = await database;

    int res = await db.update('Notification', {"isread": 1},
        where: "id = ?", whereArgs: <int>[notification.id]);

    return res > 0 ? true : false;
  }


 deleteNotifica(LocalNotification notification) async {
    final db = await database;


var res =   await   db.delete("Notification"  ,   where: "id=?" ,  whereArgs: [notification.id]);



    return res ;
  }



  Future<List<LocalNotification>> getAllNotification() async {
    final db = await database;
    var res = await db.query("Notification", where: "isread=?", whereArgs: [0]);
    List<LocalNotification> list = res.isNotEmpty
        ? res.map((c) => LocalNotification.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<int> getNotificationsCount() async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT COUNT(id) as counter from Notification where isread=0");
    debugPrint(res[0]['counter'].toString());

    return res[0]['counter'];
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Notification");
  }
}
