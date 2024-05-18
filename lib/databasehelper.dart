import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io'as io;
import 'package:path/path.dart';
import 'Model/CartModel/cartmodel.dart';
class DatabaseHelper{
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
    String path=join(documentDirectory.path, 'ProductOrderCart.db');
    var db=await openDatabase(path,version: 1,onCreate: _oncreate);
    return db;
  }
  _oncreate (Database db , int version )async{
    await db
        .execute('CREATE TABLE cartt (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,productCompany TEXT,initialPrice INTEGER, productPrice INTEGER ,productCategory TEXT, quantity INTEGER, imagePath TEXT )');
  }

  ///Function For inserting Values in Database SQLITE////////
  Future<Cart> insert(Cart cart) async{
    var dbClient=await db;
    await dbClient!.insert('cartt', cart.toMap());
    return cart;
  }
  //////Function to retrieve data from SQLITE DATABASE/////
  Future<List<Cart>> getnoteslist() async
  {
    var dbClient=await db;
    final List<Map<String, Object?>> queryresult=await dbClient!.query('cartt');
    return queryresult.map((e) => Cart.fromMap(e)).toList();
  }
  //
  ////Function For deleteing Any Data from list//////
  Future<void> deleteNote(int id) async {
    var dbClient = await db;
    await dbClient!.delete('cartt', where: 'id = ?', whereArgs: [id]);
  }
  //
  //////Function For Updating Data in SQlite /////
  Future<void> updateNote(Cart model) async {
    var dbClient = await db;
    await dbClient!.update('cartt',
        model.toMap(),
        where: 'id=?',
        whereArgs: [model.id]);
  }
  Future<void> clearCart() async {
    var dbClient = await db;
    await dbClient!.delete('cartt');
  }

}