import 'package:crypto_project/news_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc/news_bloc.dart';
import 'login/login_view.dart';


// ...


void main() {
  runApp( const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (context) =>  NewsBloc(newsApi()),
          child:
         const GoogleSignInScreen()
          // GoogleLoginPage()
          // const NewsPage(),
        ));
  }
}

