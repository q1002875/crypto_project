import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}


class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  // final GoogleSignIn _googleSignIn;
  
  final GoogleSignIn _googleSignIn ;
  GoogleAuthBloc(this._googleSignIn) : super(GoogleAuthInitial());

  @override
  Stream<GoogleAuthState> mapEventToState(GoogleAuthEvent event) async* {
    if (event is GoogleLoginButtonPressed) {
      yield GoogleAuthLoading();

      try {
         
              // final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // 登錄成功，獲取用戶信息
        final String email = googleSignInAccount.email;
        final String name = googleSignInAccount.displayName ?? '';
        final String photoUrl = googleSignInAccount.photoUrl ?? '';
        final String mangoUseId = googleSignInAccount.id;
        
          yield GoogleAuthSuccess(name);
      }

        // final googleAccount = await _googleSignIn.signIn();
        // final name = googleAccount?.displayName;

        // yield GoogleAuthSuccess(name ?? '');
      } catch (error) {
        yield GoogleAuthFailure(error.toString());
      }
    } else if (event is GoogleLogoutButtonPressed) {
      yield GoogleAuthLoading();

      try {
        await _googleSignIn.signOut();

        yield GoogleAuthInitial();
      } catch (error) {
        yield GoogleAuthFailure(error.toString());
      }
    }
  }
}
