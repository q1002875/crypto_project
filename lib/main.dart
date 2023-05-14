import 'package:crypto_project/account_Page/login/bloc/login_bloc.dart';
import 'package:crypto_project/news_Page_view/news_view.dart';
import 'package:crypto_project/routes.dart';
import 'package:crypto_project/service_Api/news_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'account_Page/login/login_provider.dart';
import 'account_Page/login/login_view.dart';
import 'bloc/bloc/news_Bloc/news_bloc.dart';
import 'crypto_Page/crypto_view_page.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => AuthenticationBloc(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthenticationBloc _authBloc;
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    BlocProvider(
      create: (context) => NewsBloc(newsApi()),
      child: const NewsPage(),
    ),
    const BinanceWebSocket(),
    const GoogleSignInScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UserProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          onGenerateRoute: Routes.generateRoute,
          home: Scaffold(
            body: Center(child:
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
              if (state is AuthenticatedisMember) {
                final isMember = (state).isMember;
                final userProvider = Provider.of<UserProvider>(context);
                if (isMember) {
                  userProvider.login();
                } else {
                  userProvider.logout();
                }
                return _widgetOptions.elementAt(_selectedIndex);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            })),
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
        ));
  }

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthenticationBloc>(context);
    _authBloc.add(CheckisMember());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
