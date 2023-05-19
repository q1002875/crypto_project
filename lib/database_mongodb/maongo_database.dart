import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../api_model/crypto_coinModel.dart';
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

enum ConnectDbName { user, crypto }

class MongoDBConnection {
  static const MONGO_URL =
      'mongodb+srv://q1002875:q1002875@cluster0.enqytre.mongodb.net/crypto?retryWrites=true&w=majority';

  static const COLLECTION_NAME_user = 'user';
  static const COLLECTION_NAME_crypto = 'crypto';
  late BuildContext context;
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

  Future<void> deleteDocument(
      Map<String, dynamic> query, ConnectDbName dbName) async {
    final collection = _db?.collection(dbName.name);
    //範例
    //  await collection.deleteOne(where.eq('name', 'username111111111'));
    await collection?.remove(query);
    print('Document deleted');
  }

  Future<void> deleteOne(
      String user, String value, ConnectDbName dbName) async {
    final collection = _db?.collection(dbName.name);
    //範例
    await collection?.deleteOne(where.eq(user, value));
    print('Document deleted');
  }

  Future<User?> getuserdocument(String id, ConnectDbName dbName) async {
    final collection = _db?.collection(dbName.name);
    try {
      final doc = await collection?.findOne(where.eq('userId', id));
      return doc != null ? User.fromJson(doc) : null;
    } catch (error) {
      return null;
    }
    //  print(doc);
  }

  Future<UserCryptoData?> getUserCryptoData(String id, ConnectDbName dbName) async {
    final collection = _db?.collection(dbName.name);
    try {
      final doc = await collection?.findOne(where.eq('userId', id));
      debugPrint('拿資料doc:$doc');
      return doc != null ? UserCryptoData.fromJson(doc) : null;
    } catch (error) {
      return null;
    }
    //  print(doc);
  }

//  UserCryptoData

  Future<bool> insertDocument(
      Map<String, dynamic> document, ConnectDbName dbName) async {
    try {
      final collection = _db?.collection(dbName.name);
      final id = ObjectId().toHexString();
      document['_id'] = id;
      await collection?.insertOne(document);
      return true;
    } catch (e) {
      return false;
    }
  }

Future<void> showUpdateResultDialog(
      BuildContext context, bool isSuccess,String text) async {
    final message = isSuccess ? text : '資料更新失敗，請稍後再試。';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '更新結果',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  child: const Text(
                    '確定',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<bool> updateDocument(Map<String, dynamic> query,
      Map<String, dynamic> update, ConnectDbName dbName,String text) async {
    try {
      final collection = _db?.collection(dbName.name);
      final result = await collection?.update(query, update);
      final isSuccess = result != null; // 根據 result 是否為 null 判斷是否成功
      // 顯示彈出視窗提醒更新結果
      showUpdateResultDialog(context, isSuccess,text);

      return isSuccess;
    } catch (error) {
      // 更新時出現異常，顯示彈出視窗提醒更新失敗
      showUpdateResultDialog(context, false,'');
      return false;
    }
  }

}
