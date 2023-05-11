import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';



// class MongoDatabase {
//   static connect() async {
//     var db = await Db.create(MONGO_URL);
//     await db.open();
//     inspect(db);
//     var collection = db.collection('crypto');
//     await collection.update(where.eq('user', 'user'),modify.set('email', 'dafsd@ffdsf'));
//     await collection.insertOne({
//       'user': 'user',
//       'email': 'user@gmail.com1111111',
//       'name': 'username111111111',
//     });
//     await collection.deleteOne({"name":"username111111111"});

//   }

// }
// var status = db.serverStatus();
//  print(status);
//  print(await collection.find().toList());

class MongoDatabase {
  static const MONGO_URL =
      'mongodb+srv://q1002875:q1002875@cluster0.enqytre.mongodb.net/crypto?retryWrites=true&w=majority';
  static const COLLECTION_NAME_crypto = 'crypto';
  
  
  static Future<void> connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var collection = _getCollection(db);
    await _updateDocument(collection);
    await _insertDocument(collection);
    await _deleteDocument(collection);
  }

  static DbCollection _getCollection(Db db) {
    return db.collection(COLLECTION_NAME_crypto);
  }

  static Future<void> _updateDocument(DbCollection collection) async {
    try {
      await collection.updateOne(
        where.eq('user', 'user'),
        modify.set('email', 'dafsd@ffdsf'),
      );
      print('Document updated successfully.');
    } catch (e) {
      print('Failed to update document: $e');
    }
  }

  static Future<void> _insertDocument(DbCollection collection) async {
    try {
      await collection.insertOne({
        'user': 'user',
        'email': 'user@gmail.com1111111',
        'name': 'username111111111',
      });
      print('Document inserted successfully.');
    } catch (e) {
      print('Failed to insert document: $e');
    }
  }

  static Future<void> _deleteDocument(DbCollection collection) async {
    try {
      await collection.deleteOne(where.eq('name', 'username111111111'));
      print('Document deleted successfully.');
    } catch (e) {
      print('Failed to delete document: $e');
    }
  }
}



class MongoDBConnection {
  Db? _db;

 static const MONGO_URL =
      'mongodb+srv://q1002875:q1002875@cluster0.enqytre.mongodb.net/crypto?retryWrites=true&w=majority';
      static const COLLECTION_NAME_crypto = 'crypto';
  
  
  Future<void> connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    _db = db;
    print('Connected to MongoDB');
  }

  Future<void> insertDocument(Map<String, dynamic> document) async {
    final collection = _db?.collection(COLLECTION_NAME_crypto);
    final id = ObjectId().toHexString();
    document['_id'] = id;
    await collection?.insertOne(document);
    print('Document inserted');
  }

  Future<void> updateDocument(
      Map<String, dynamic> query, Map<String, dynamic> update) async {
    final collection = _db?.collection(COLLECTION_NAME_crypto);
    await collection?.update(query, update);
    print('Document updated');
  }

  Future<void> deleteDocument(Map<String, dynamic> query) async {
    final collection = _db?.collection(COLLECTION_NAME_crypto);
    await collection?.remove(query);
    print('Document deleted');
  }

  Future<void> close() async {
    await _db?.close();
    print('Disconnected from MongoDB');
  }
}
