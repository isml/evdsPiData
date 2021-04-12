import 'dart:io';

import 'package:evdspidata/models/kurlar.dart';
import 'package:evdspidata/models/paraBirim.dart';
import 'package:evdspidata/models/vtKurlar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;

class Db {
  static Database _db;

  final String tableParaBirim = 'ParaBirim';

  final String cId = 'id';
  final String cBr = 'birim';
  final String cUlke = 'ulke';
  final String cAciklama = 'aciklama';
  //////////////////////////////////////

  final String tableKurlar = 'Kurlar';

  final String kId = 'id';
  final String kUsd = 'usd';
  final String kEur = 'eur';
  final String kChf = 'chf';
  final String kGbp = 'gbp';
  final String kJpy = 'jpy';
  final String kTarih = 'tarih';
  ////////////

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'evds.db');

    //String path =  join(documentsDirectory.path, 'ingilizceDefter.db');
    var myDb = await openDatabase(path, version: 3, onCreate: _onCreate);
    return myDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $tableParaBirim($cId INTEGER PRIMARY KEY AUTOINCREMENT,$cBr TEXT,$cUlke TEXT,$cAciklama TEXT)');

    await db.execute(
        'CREATE TABLE $tableKurlar($kId INTEGER PRIMARY KEY AUTOINCREMENT,$kUsd TEXT,$kEur TEXT,$kChf TEXT,$kGbp TEXT,$kJpy TEXT,$kTarih TEXT)');
  }

  Future<int> deleteBirim(int id) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawDelete('DELETE FROM $tableParaBirim WHERE $cId= $id');
    });
  }

  Future<int> updateBirim(ParaBirim paraBirim) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawUpdate(
          'UPDATE $tableParaBirim SET $cBr= \'${paraBirim.birim}\',$cUlke= \'${paraBirim.ulke}\',$cAciklama= \'${paraBirim.aciklama}\'');
    });
  }

  void SaveBirim(ParaBirim paraBirim) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO $tableParaBirim ($cBr,$cUlke,$cAciklama) VALUES (' +
              '\'' +
              paraBirim.birim +
              '\'' +
              ',' +
              '\'' +
              paraBirim.ulke +
              '\'' +
              ',' +
              '\'' +
              paraBirim.aciklama +
              '\''
                  ')');
    });
  }

  Future<List<ParaBirim>> getParaBirim() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ParaBirim');
    List<ParaBirim> paraBirimler = List();
    for (int i = 0; i < list.length; i++) {
      paraBirimler.add(ParaBirim(list[i]['id'], list[i]['birim'].toString(),
          list[i]['ulke'].toString(), list[i]['aciklama'].toString()));
    }
    return paraBirimler;
  }

//////// vt ye kaydedilen kurların vt kısmı burada başlıyor
  Future<List<VtKurlar>> getKurlar() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Kurlar');
    List<VtKurlar> vtKurlar = List();
    for (int i = 0; i < list.length; i++) {
      vtKurlar.add(VtKurlar(
          list[i]['id'],
          list[i]['usd'].toString(),
          list[i]['eur'].toString(),
          list[i]['chf'].toString(),
          list[i]['gbp'].toString(),
          list[i]['jpy'].toString(),
          list[i]['tarih'].toString()));
    }
    return vtKurlar;
  }

  void SaveKurlar(VtKurlar kurlar) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO $tableKurlar($kUsd,$kEur,$kChf,$kGbp,$kJpy,$kTarih) VALUES (' +
              '\'' +
              kurlar.usd +
              '\'' +
              ',' +
              '\'' +
              kurlar.eur +
              '\'' +
              ',' +
              '\'' +
              kurlar.chf +
              '\''
                  ',' +
              '\'' +
              kurlar.gbp +
              '\''
                  ',' +
              '\'' +
              kurlar.jpy +
              '\''
                  ',' +
              '\'' +
              kurlar.tarih +
              '\''
                  ')');
    });
  }

  Future<int> updateKurlar(VtKurlar kurlar) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawUpdate(
          'UPDATE $tableKurlar SET $kUsd= \'${kurlar.usd}\',$kEur= \'${kurlar.eur}\',$kChf= \'${kurlar.chf}\',$kGbp= \'${kurlar.gbp}\',$kJpy= \'${kurlar.jpy}\',$kTarih= \'${kurlar.tarih}\'');
    });
  }
}
