import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../extension/image_url.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String mail = '';
  String googlename = '';
  String googleurl = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Google 登錄'),
      ),
      body: Center(
          child: Column(
        children: [
          Text(googlename),
          Text(mail),
          NetworkImageWithPlaceholder(
            imageUrl: googleurl,
            width: 100,
            height: 100,
          ),
          ElevatedButton(
            onPressed: _handleSignIn,
            child: const Text('使用 Google 登錄'),
          ),
        ],
      )),
    ));
  }

  void signIn() {
    // AuthService().singInWithGoogle();
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // 登錄成功，獲取用戶信息
        final String email = googleSignInAccount.email;
        final String name = googleSignInAccount.displayName ?? '';
        final String photoUrl = googleSignInAccount.photoUrl ?? '';
        final String mangoUseId = googleSignInAccount.id;
        // TODO: 將用戶信息保存到 MongoDB
        setState(() {
          mail = email;
          googlename = mangoUseId;
          googleurl = photoUrl;
        });
        // ignore: use_build_context_synchronously
        // Navigator.pushNamed(context, Routes.newPage);
      }
    } catch (error) {
      print('Failed to sign in with Google: $error');
    }
  }
}
