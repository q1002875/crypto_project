import 'package:crypto_project/account_Page/account_view.dart';
import 'package:crypto_project/account_Page/login/bloc/login_bloc.dart';
import 'package:crypto_project/news_Page_view/news_view.dart';
import 'package:crypto_project/routes.dart';
import 'package:crypto_project/service_Api/news_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc/news_Bloc/news_bloc.dart';
import 'crypto_Page/crypto_view_page.dart';

void main() {
  runApp(
      const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {


     final List<Widget> widgetOptions = [
      BlocProvider(
        create: (context) => NewsBloc(newsApi()),
        child: const NewsPage(),
      ),
      const BinanceWebSocket(),
      // AccountPage(_authBloc)
      BlocProvider(
          create: (context) => AuthenticationBloc(),
          child: const AccountPage())
    ];
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      onGenerateRoute: Routes.generateRoute,
      home: Scaffold(
        body: Center(child: widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.query_stats_rounded),
              label: 'Crypto',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
