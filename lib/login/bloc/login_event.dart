part of 'login_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CheckMemberEvent extends AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {}

class LogoutEvent extends AuthenticationEvent {}