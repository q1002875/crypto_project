part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}


// 定義狀態
abstract class GoogleAuthState {}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleAuthSuccess extends GoogleAuthState {
  final String name;

  GoogleAuthSuccess(this.name);
}

class GoogleAuthFailure extends GoogleAuthState {
  final String error;

  GoogleAuthFailure(this.error);
}
