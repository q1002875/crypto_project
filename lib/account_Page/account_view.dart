import 'package:flutter/material.dart';
import '../api_model/user_infoModel.dart';
import '../extension/custom_text.dart';
import '../login/auth_repository.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AuthRepository authRepository = AuthRepository();
   User? userinfo  ;
  @override
  void initState()async {
    super.initState();
   userinfo = await authRepository.checkMember();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.amber,
        appBar: AppBar(
            title:  CustomText(
          textContent: userinfo?.displayName ?? '',
          textColor: Colors.white,
        )),
        body: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    authRepository.loginWithGoogle();
                  },
                  child: const Text('google登入'),
                ),
                ElevatedButton(
                  onPressed: () {
                    authRepository.logout();
                  },
                  child: const Text('登出'),
                ),
              ],
            )));
  }
}
