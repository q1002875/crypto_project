// import 'package:flutter/cupertino.dart';

// import '../database_mongodb/maongo_database.dart';

// class CryptoMongoRepositorty {
//   final MongoDBConnection connection = MongoDBConnection();

//   Future<void> addSubscripCoin(Map<String, String> document) async {
//     try {
//       connection.insertDocument(document, ConnectDbName.crypto);
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//   }

//   Future<void> connectMongo() async {
//     try {
//       connection.connect();
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//   }

//   Future<void> deleteSubscripCoin(Map<String, String> document) async {
//     try {
//       connection.deleteDocument(document, ConnectDbName.crypto);
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//   }

//   void disConnectMongo() {
//     connection.close();
//   }

//   Future<void> getSubscripCoinData(Map<String, String> document) async {}
// }
