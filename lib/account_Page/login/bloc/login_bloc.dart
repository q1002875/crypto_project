import 'package:bloc/bloc.dart';
import 'package:crypto_project/api_model/user_infoModel.dart';
import 'package:crypto_project/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../database_mongodb/maongo_database.dart';
import '../../../extension/SharedPreferencesHelper.dart';

part 'login_event.dart';
part 'login_state.dart';

// Authentication Bloc
// Authentication Bloc
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final MongoDBConnection connection = MongoDBConnection();
  var isloginin = false;
  AuthenticationBloc() : super(UnauthenticatedState()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(AuthenticationLoading());
        try {
          final user = await _mapLoginEventToState();
          emit(AuthenticatedState(user!));
        } catch (_) {
          emit(UnauthenticatedState());
        }
      } else if (event is CheckisMember) {
        emit(AuthenticationLoading());
        try {
          final user = await _checkMongoMember();
          if (user != null) {
            isloginin = true;
            // event.userProvider.login();
            emit(AuthenticatedisMember(true, user));
          } else {
            isloginin = false;
            // event.userProvider.logout();
            emit(AuthenticatedisMember(false, null));
          }
        } catch (_) {
          // emit(UnauthenticatedState());
        }
      } else if (event is LogoutEvent) {
        emit(AuthenticationLoading());

        try {
          _clearUserData();
          emit(AuthenticationLoginOut());
        } catch (_) {
          emit(UnauthenticatedState());
        }
      } else {
        return;
      }
    });
  }

  Future<User?> _checkMongoMember() async {
    try {
      final userid = await SharedPreferencesHelper.getString('userId');
      return await mongodb.getuserdocument(userid, ConnectDbName.user);
    } catch (error) {
      print('Failed to sign in with Google: $error');
    }
    return null;
  }

  Future<void> _clearUserData() async {
    final userid = await SharedPreferencesHelper.getString('userId');
    mongodb.deleteOne('userId', userid, ConnectDbName.user);
    googleSignIn.signOut();
    SharedPreferencesHelper.setString('userId', '');
  }

  Future<void> _insertDataToMongo(User user) async {
    try {
      final document = {
        '_id': user.id,
        'userId': user.userId,
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl
      };
      mongodb.insertDocument(document, ConnectDbName.user);
    } catch (error) {
      print('Failed to sign in with Google: $error');
    }
  }

  Future<User?> _mapLoginEventToState() async {
    final googleSignInAccount = await googleSignIn.signIn();
    final googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    if (googleSignInAuthentication != null) {
      print('google有資料');
      // 从Google获取用户信息
      final String email = googleSignInAccount!.email;
      final String photoUrl = googleSignInAccount.photoUrl ?? '';
      final String mangoUseId = googleSignInAccount.id;
      final String displayName = googleSignInAccount.displayName ?? '';
      // 存储用户信息到MongoDB
      final id = ObjectId().toHexString();
      User users = User(
          id: id,
          userId: mangoUseId,
          displayName: displayName,
          email: email,
          photoUrl: photoUrl);

      await _insertDataToMongo(users);
      SharedPreferencesHelper.setString('userId', mangoUseId);
      return users;
    } else {
      print('googlesign is null');
      return null;
    }
  }
}
