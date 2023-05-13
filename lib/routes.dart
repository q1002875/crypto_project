import 'package:crypto_project/account_Page/account_view.dart';
import 'package:crypto_project/crypto_Page/crypto_view_page.dart';
import 'package:crypto_project/news_Page_view/news_cell_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'account_Page/login/bloc/login_bloc.dart';
import 'api_model/news_totalModel.dart';
import 'bloc/bloc/news_Bloc/news_bloc.dart';
import 'news_Page_view/news_view.dart';
import 'news_api.dart';

class Routes {
  // ...
  static const String home = '/';
  static const String newPage = '/newsPage';
  static const String newsDetail = '/newPage/detail';
  static const String crypto = '/cryptoPage';
  static const String account = '/newPage/accountPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case home:
        // return MaterialPageRoute(builder: (_) => const GoogleSignInScreen());
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => NewsBloc(newsApi()),
                child: const NewsPage()));
      case newPage:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => NewsBloc(newsApi()),
                child: const NewsPage()));
      case newsDetail:
        if (args is ArticleModel) {
          // 將參數傳遞給NewsDetail頁面
          return MaterialPageRoute(builder: (_) => NewsDetail(news: args));
        }
        return _errorRoute();
      case account:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => AuthenticationBloc(),
                child: const HomePage()));

      case crypto:
        return MaterialPageRoute(builder: (_) => const CryptoPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) => const UnknownRoutePage());
  }
}

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
