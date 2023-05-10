import 'package:crypto_project/routes.dart';
import 'package:flutter/material.dart';

// ...

void main() {
  runApp(const MyApp2());
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
      onGenerateRoute: Routes.generateRoute,
      // home:onGenerateRoute: Routes.generateRoute,

      //  BlocProvider(
      //   create: (context) =>  NewsBloc(newsApi()),
      //   child:
      //  const GoogleSignInScreen()
      //   // GoogleLoginPage()
      //   // const NewsPage(),
      // )
    );
  }
}
