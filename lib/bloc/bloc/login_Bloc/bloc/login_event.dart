part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

abstract class GoogleAuthEvent {}

class GoogleLoginButtonPressed extends GoogleAuthEvent {}

class GoogleLogoutButtonPressed extends GoogleAuthEvent {}
