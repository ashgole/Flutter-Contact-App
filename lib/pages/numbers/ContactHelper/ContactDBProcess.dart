///data/data/com.example.numbers
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:numbers/pages/numbers/ContactHelper/ContactHelper.dart';

class ContactDBProcess {
  static Database _db;
  static const String ContactListTable = 'ContactListTable';
  static const String db_name = 'ASHABBTEZZACONTACT.db';

//======================*
  static const String id = 'id';
  static const String name = 'name';
  static const String numbers = 'numbers';

//======================^
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    //dropDb();
    _db = await initDb();
    return _db;
  }

//======================*
  initDb() async {
// io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(await getDatabasesPath(), db_name);
    var db = await openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  dropDb() async {
    String databasePath = join(await getDatabasesPath(), db_name);
    var deleteDatabase2 = await deleteDatabase(databasePath);
    print('1.Datababe Dropped');
    return deleteDatabase2;
  }

  onCreate(Database db, int version) async {
    print('2.Datababe Created');
    await db.execute(
        "create table $ContactListTable($id integer primary key,$name text,$numbers text)");
    print('3.all table created');
  }

//======================^
//======================*
  Future<ContactHelper> saveContactListTable(ContactHelper e2) async {
    var dbClient = await db;
    e2.id = await dbClient.insert(ContactListTable, e2.toMap());
    return e2;
  }

  //======================*
  Future<List<ContactHelper>> getContactListTable() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(ContactListTable,
        columns: [id, name, numbers], orderBy: "name ASC");
    List<ContactHelper> person = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        person.add(ContactHelper.fromMap(maps[i]));
      }
    }
    return person;
  }

  //======================*
  Future<List<ContactHelper>> getContactListTableOnly(nameNumber) async {
    //okash
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT *  FROM $ContactListTable where name LIKE  '$nameNumber%'  or numbers LIKE  '$nameNumber%' ");

    List<ContactHelper> person = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        person.add(ContactHelper.fromMap(maps[i]));
      }
    }
    return person;
  }

//======================^
  Future<int> update(ContactHelper e3) async {
    var dbClient = await db;
    return await dbClient.update(ContactListTable, e3.toMap(),
        where: '$id = ?', whereArgs: [e3.id]);
  }

//======================^
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(ContactListTable, where: 'id=?', whereArgs: [id]);
  }

  //======================*
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
