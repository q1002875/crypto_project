
import 'package:google_sign_in/google_sign_in.dart';

import '../api_model/user_infoModel.dart';
import '../database_mongodb/maongo_database.dart';
import '../extension/SharedPreferencesHelper.dart';

class AuthRepository {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<void> loginWithGoogle() async {
    try {
      // 使用 Google 登入
     final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // 登錄成功，獲取用戶信息
        final String email = googleSignInAccount.email;
        final String displayName = googleSignInAccount.displayName ?? '';
        final String photoUrl = googleSignInAccount.photoUrl ?? '';
        final String mangoUseId = googleSignInAccount.id;
        // TODO: 將用戶信息保存到 MongoDB
        final document = {
          'userId':mangoUseId,
          'displayName': displayName,
          'email': email,
          'photoUrl': photoUrl,
        };
        _connectMongo(document);
        SharedPreferencesHelper.setString('userId', mangoUseId );
      }

      // // 檢查用戶是否存在
      // final snapshot = await _usersCollection.doc(googleUser.id).get();
      // if (!snapshot.exists) {
      //   // 如果用戶不存在，創建新用戶
      //   final newUser = User(
      //     id: googleUser.id,
      //     email: googleUser.email,
      //     name: googleUser.displayName ?? '',
      //     photoUrl: googleUser.photoUrl ?? '',
      //   );
      //   await _usersCollection.doc(googleUser.id).set(newUser.toMap());
      //   return newUser;
      // } else {
      //   // 如果用戶已存在，返回用戶信息
      //   final user = User.fromMap(snapshot.data()!);
      //   return user;
      // }
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<User?> checkMember() async {
    final userid = await SharedPreferencesHelper.getString('userId', defaultValue: '');
    if (userid != ''){
      final MongoDBConnection connection;
      connection = MongoDBConnection();
      await connection.connect();
      final data = connection.getuserdocument(userid);
      print(data);
      
    }else{
      return null;
      }
    return null;
   
    // return User(id: id, displayName: displayName, email: email, photoUrl: photoUrl);
  }



  Future<void> _connectMongo(Map<String, String> document) async {
    try {
      final MongoDBConnection connection;
      connection = MongoDBConnection();
      await connection.connect();
      connection.insertDocument(document);
    } catch (error) {
      print('Failed to sign in with Google: $error');
    }
  }


  Future<void> logout() async {
    await googleSignIn.signOut();

    final userid = await SharedPreferencesHelper.getString('userId', defaultValue: '');
    final MongoDBConnection connection;
    connection = MongoDBConnection();
    await connection.connect();
    connection.deleteOne('userId', userid);
    //delemongodb user
  }
}
