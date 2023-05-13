part of 'login_bloc.dart';

class AuthenticatedisMember extends AuthenticationState {
  final bool isMember;
  final User? user;
  AuthenticatedisMember(this.isMember, this.user);
}

class AuthenticatedState extends AuthenticationState {
  final User user;
  AuthenticatedState(this.user);
}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationLoginOut extends AuthenticationState {}

abstract class AuthenticationState {}

class InitialState extends AuthenticationState {}

class UnauthenticatedState extends AuthenticationState {}
