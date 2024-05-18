import 'package:pharmasage/Model/InventoryCartModel/InevntoryCart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io'as io;
import 'package:path/path.dart';
class InventoryDatabaseHelper{
  static Database? _db;
  Future<Database?> get db async
  {
    if(_db!=null)
    {
      return _db;
    }
    _db=await initDatabase();
    return _db;
  }
  initDatabase()async{
    io.Directory documentDirectory=await getApplicationDocumentsDirectory();
    String path=join(documentDirectory.path, 'InventoryProductOrderCart.db');
    var db=await openDatabase(path,version: 1,onCreate: _oncreate);
    return db;
  }
  _oncreate (Database db , int version )async{
    await db
        .execute('CREATE TABLE cartt (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productExpiry TEXT,productName TEXT,initialPrice INTEGER, productPrice INTEGER ,productCategory TEXT, productQuantity INTEGER,lowStockWarning INTEGER, imagePath TEXT )');
  }

  ///Function For inserting Values in Database SQLITE////////
  Future<InventoryCart> insert(InventoryCart cart) async{
    var dbClient=await db;
    await dbClient!.insert('Inventorycartt', cart.toMap());
    return cart;
  }
  //////Function to retrieve data from SQLITE DATABASE/////
  Future<List<InventoryCart>> getnoteslist() async
  {
    var dbClient=await db;
    final List<Map<String, Object?>> queryresult=await dbClient!.query('Inventorycartt');
    return queryresult.map((e) => InventoryCart.fromMap(e)).toList();
  }
  //
  ////Function For deleteing Any Data from list//////
  Future<void> deleteNote(int id) async {
    var dbClient = await db;
    await dbClient!.delete('Inventorycartt', where: 'id = ?', whereArgs: [id]);
  }
  //
  //////Function For Updating Data in SQlite /////
  Future<void> updateNote(InventoryCart model) async {
    var dbClient = await db;
    await dbClient!.update('Inventorycartt',
        model.toMap(),
        where: 'id=?',
        whereArgs: [model.id]);
  }
  Future<void> clearCart() async {
    var dbClient = await db;
    await dbClient!.delete('Inventorycartt');
  }

}