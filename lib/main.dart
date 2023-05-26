import 'package:crypto_project/account_Page/account_view.dart';
import 'package:crypto_project/account_Page/login/bloc/login_bloc.dart';
import 'package:crypto_project/news_Page_view/news_view.dart';
import 'package:crypto_project/routes.dart';
import 'package:crypto_project/service_Api/news_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc/news_Bloc/news_bloc.dart';
import 'crypto_Page/crypto_view_page.dart';
import 'database_mongodb/maongo_database.dart';

Future<void> main() async {
  // Ensure Flutter widget binding
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app with SplashScreen
  runApp(const MyApp());
}

final mongodb = MongoDBConnection();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const SplashScreen(),
    );
  }
}

class MyAppAfterSplash extends StatefulWidget {
  const MyAppAfterSplash({super.key});

  @override
  _MyAppAfterSplashState createState() => _MyAppAfterSplashState();
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _MyAppAfterSplashState extends State<MyAppAfterSplash> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      BlocProvider(
        create: (context) => NewsBloc(newsApi()),
        child: const NewsPage(),
      ),
      const BinanceWebSocket(),
      //  CryptoSearchPage(''),
      // AccountPage(_authBloc)
      BlocProvider(
          create: (context) => AuthenticationBloc(), child: const AccountPage())
    ];
    return MaterialApp(
        onGenerateRoute: Routes.generateRoute,
        initialRoute: Routes.home,
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
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _SplashScreenState extends State<SplashScreen> {
  bool isConnected = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
            child: isConnected
                ? const MyAppAfterSplash()
                : Scaffold(
                    body: Center(
                    child: SizedBox(
                      width: 160,
                      height: 160,
                      child: Image.asset('assets/cryptoIcon.png'),
                    ),
                  ))));
  }

  Future<void> initApp() async {
    await mongodb.connect();
    setState(() {
      isConnected = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initApp();
  }
}
