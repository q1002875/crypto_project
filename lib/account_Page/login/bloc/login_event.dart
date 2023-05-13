part of 'login_bloc.dart';

// 登录事件
abstract class AuthenticationEvent {}

class CheckisMember extends AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {}

class LogoutEvent extends AuthenticationEvent {}
