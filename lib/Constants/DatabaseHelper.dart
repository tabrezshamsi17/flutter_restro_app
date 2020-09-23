import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "restro.db";
  static final _databaseVersion = 1;

  static final cartTable = 'cart';
  static final userData = 'userData';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $userData (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_uid INTEGER,
            user_name TEXT NOT NULL,
            user_number TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $cartTable (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            dish_id INTEGER,
            dish_name TEXT NOT NULL,
            dish_price TEXT NOT NULL,
            dish__calories TEXT NOT NULL,
            dish_qty TEXT NOT NULL
          )
          ''');
  }

  Future<int> addCart(String dish_id, String dish_name, String dish_price,
      String dish__calories, String dish_qty) async {
    Database db = await instance.database;
    return await db.rawInsert(
        "INSERT INTO $cartTable (dish_id,dish_name,dish_price,dish__calories, dish_qty) VALUES('" +
            dish_id +
            "','" +
            dish_name +
            "','" +
            dish_price +
            "','" +
            dish__calories +
            "','" +
            dish_qty +
            "')");
  }

  Future<int> addUser(
      String user_uid, String user_name, String user_number) async {
    Database db = await instance.database;
    return await db.rawInsert(
        "INSERT INTO $userData (user_uid,user_name,user_number) VALUES('" +
            user_uid +
            "','" +
            user_name +
            "','" +
            user_number +
            "')");
  }

  Future<List<Map<String, dynamic>>> getCart() async {
    Database db = await instance.database;
    return await db.query("$cartTable", orderBy: "_id DESC");
  }

  Future<int> getCount(String id) async {
    Database db = await instance.database;
    var x = await db
        .rawQuery('SELECT COUNT(dish_qty) from $cartTable where dish_id=$id');
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<List<Map<String, dynamic>>> getDishId() async {
    Database db = await instance.database;
    return await db.rawQuery("SELECT dish_id from $cartTable");
  }

  Future<List<Map<String, dynamic>>> getCartCount() async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT COUNT (*) as counts,sum(dish_price) as totalSum from $cartTable');
  }

  Future<int> deleteCart() async {
    Database db = await instance.database;
    int result = await db.delete('$cartTable');
    return result;
  }

  Future<int> getUserCount() async {
    Database db = await instance.database;
    var x = await db.rawQuery('SELECT COUNT (*) from $userData');
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<List<Map<String, dynamic>>> getUserData() async {
    Database db = await instance.database;
    return await db.query("$userData");
  }

  Future<int> deleteUser() async {
    Database db = await instance.database;
    int result = await db.delete('$userData');
    return result;
  }

}
