part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

class InitialState extends LoginState {}

class LoginedState extends LoginState {
  final User userinfo;

  const LoginedState(required this.userinfo);

  @override
  User get props => userinfo;
}

class UnauthenticatedState extends LoginState {}
