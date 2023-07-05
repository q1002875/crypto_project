import 'package:crypto_project/main.dart';

import '../../api_model/user_infoModel.dart';
import '../../common.dart';
import '../../database_mongodb/maongo_database.dart';
import '../../extension/SharedPreferencesHelper.dart';

class AuthRepository {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<User?> checkMember() async {
    final userid =
        await SharedPreferencesHelper.getString('userId', defaultValue: '');
    if (userid != '') {
      await mongodb.connect();
      final data = mongodb.getuserdocument(userid, ConnectDbName.user);
      print(data);
    } else {
      return null;
    }
    return null;

    // return User(id: id, displayName: displayName, email: email, photoUrl: photoUrl);
  }

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
          'userId': mangoUseId,
          'displayName': displayName,
          'email': email,
          'photoUrl': photoUrl,
        };
        _connectMongo(document);
        SharedPreferencesHelper.setString('userId', mangoUseId);
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> logout() async {
    await googleSignIn.signOut();

    final userid =
        await SharedPreferencesHelper.getString('userId', defaultValue: '');
    mongodb.deleteOne('userId', userid, ConnectDbName.user);
    //delemongodb user
  }

  Future<bool> _connectMongo(Map<String, String> document) async {
    try {
      mongodb.insertDocument(document, ConnectDbName.user);
      return true;
    } catch (error) {
      return false;
    }
  }
}
