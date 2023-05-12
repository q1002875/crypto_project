import 'package:bloc/bloc.dart';
import 'package:crypto_project/api_model/user_infoModel.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitialState()) {
    on<LoginEvent>((event, emit) {
      if (event is CheckMemberEvent){
        // emit(NewsLoading());
        try {
          // final arts = await news.getArticleReport('crypto');
          final user = User(id: id, userId: userId, displayName: displayName, email: email, photoUrl: photoUrl)
          emit((LoginedState: user);)
        } catch (_) {
          emit(UnauthenticatedState());
        }

       }







      // TODO: implement event handler
    });
  }
}
