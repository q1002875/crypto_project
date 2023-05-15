import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';

import '../api_model/user_infoModel.dart';

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

class MongoDBConnection {
  static const MONGO_URL =
      'mongodb+srv://q1002875:q1002875@cluster0.enqytre.mongodb.net/crypto?retryWrites=true&w=majority';

  static const COLLECTION_NAME_crypto = 'user';
  Db? _db;

  Future<void> close() async {
    await _db?.close();
    print('Disconnected from MongoDB');
  }

  Future<void> connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    _db = db;
    print('Connected to MongoDB');
  }

  Future<void> deleteDocument(Map<String, dynamic> query) async {
    final collection = _db?.collection(COLLECTION_NAME_crypto);
    //範例
    //  await collection.deleteOne(where.eq('name', 'username111111111'));
    await collection?.remove(query);
    print('Document deleted');
  }

  Future<void> deleteOne(String user, String value) async {
    final collection = _db?.collection(COLLECTION_NAME_crypto);
    //範例
    await collection?.deleteOne(where.eq(user, value));
    print('Document deleted');
  }

  Future<User?> getuserdocument(String id) async {
    final collection = _db?.collection(COLLECTION_NAME_crypto);
    try {
      final doc = await collection?.findOne(where.eq('userId', id));
      return doc != null ? User.fromJson(doc) : null;
    } catch (error) {
      return null;
    }

    //  print(doc);
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
    //範例
    // await collection.updateOne(
    //   where.eq('user', 'user'),
    //   modify.set('email', 'dafsd@ffdsf'),
    // );

    final collection = _db?.collection(COLLECTION_NAME_crypto);
    await collection?.update(query, update);
    print('Document updated');
  }
}
