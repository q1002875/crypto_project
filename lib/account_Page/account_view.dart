import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login/bloc/login_bloc.dart';

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
            if (state is AuthenticationLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AuthenticatedisMember) {
              if (state.isMember) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('已經是mongo會員, ${state.user!.displayName}'),
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
            } else if (state is AuthenticatedState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome, ${state.user.displayName}'),
                  ElevatedButton(
                    onPressed: () {
                      _authBloc.add(LogoutEvent());
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              );
            } else if (state is UnauthenticatedState) {
              return const Text('失敗');
            } else {
              return ElevatedButton(
                onPressed: () {
                  _authBloc.add(LoginEvent());
                },
                child: const Text('不是會員按google登入'),
              );
            }

            // if (state is AuthenticatedState) {
            //   return Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text('Welcome, ${state.user.displayName}!'),
            //       ElevatedButton(
            //         onPressed: () {
            //           _authBloc.add(LogoutEvent());
            //         },
            //         child: const Text('Sign Out'),
            //       ),
            //     ],
            //   );
            // } else if (state is AuthenticatedisMember) {
            //   return state.isMember
            //       ? Text('是mongo會員${state.user!.displayName}')
            //       : const Text('不是會員請求登入');
            // } else {
            //   return ElevatedButton(
            //     onPressed: () {
            //       _authBloc.add(LoginEvent());
            //     },
            //     child: const Text('Sign In with Google'),
            //   );
            // }
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
}
