import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login/bloc/login_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthenticationBloc _authBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Demo'),
      ),
      body: Center(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return _buildContent(context, state);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthenticationBloc>(context);
    _authBloc.add(CheckisMember());
  }

  Widget _buildContent(BuildContext context, AuthenticationState state) {
    switch (state.runtimeType) {
      case AuthenticationLoading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case AuthenticatedisMember:
        final isMember = (state as AuthenticatedisMember).isMember;
        final user = (state).user;
        if (isMember) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('已經是mongo會員, ${user!.displayName}'),
              ElevatedButton(
                onPressed: () {
                  _authBloc.add(LogoutEvent());
                },
                child: const Text('Sign Out'),
              ),
            ],
          );
        } else {
          return ElevatedButton(
            onPressed: () {
              _authBloc.add(LoginEvent());
            },
            child: const Text('不是會員按google登入'),
          );
        }
      case AuthenticatedState:
        final user = (state as AuthenticatedState).user;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${user.displayName}'),
            ElevatedButton(
              onPressed: () {
                _authBloc.add(LogoutEvent());
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      case AuthenticationLoginOut:
        return ElevatedButton(
          onPressed: () {
            _authBloc.add(LoginEvent());
          },
          child: const Text('不是會員按google登入'),
        );
      case UnauthenticatedState:
        return const Text('失敗');
      default:
        return ElevatedButton(
          onPressed: () {
            _authBloc.add(LoginEvent());
          },
          child: const Text('不是會員按google登入'),
        );
    }
  }
}
