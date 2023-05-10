import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_bloc.dart';

class GoogleLoginPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Google 登入'),
      ),
      body: BlocProvider(
        create: (context) => GoogleAuthBloc(_googleSignIn),
        child: BlocConsumer<GoogleAuthBloc, GoogleAuthState>(
          listener: (context, state) {
            if (state is GoogleAuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('歡迎回來，${state.name}！'),
                ),
              );
            } else if (state is GoogleAuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('操作失敗：${state.error}'),
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: state is GoogleAuthLoading
                  ? const CircularProgressIndicator()
                  : state is GoogleAuthSuccess
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('您已登入：${state.name}'),
                           const SizedBox(height: 16),
                            ElevatedButton(
                              child:const Text('登出'),
                              onPressed: () {
                                context.read<GoogleAuthBloc>().add(
                                      GoogleLogoutButtonPressed(),
                                    );
                              },
                            ),
                          ],
                        )
                      : ElevatedButton(
                          child:const Text('使用 Google 登入'),
                          onPressed: () {
                            context.read<GoogleAuthBloc>().add(
                                  GoogleLoginButtonPressed(),
                                );
                          },
                        ),
            );
          },
        ),
      ),
    );
  }
}
