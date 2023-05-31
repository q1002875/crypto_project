import 'package:crypto_project/account_Page/login/bloc/login_bloc.dart';
import 'package:crypto_project/crypto_Page/crypto_detail_chart.dart';
import 'package:crypto_project/crypto_Page/crypto_search_page.dart';
import 'package:crypto_project/news_Page_view/news_cell_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'account_Page/account_view.dart';
import 'api_model/news_totalModel.dart';
import 'bloc/bloc/news_Bloc/news_bloc.dart';
import 'news_Page_view/news_view.dart';
import 'service_Api/news_api.dart';

class Routes {
  // ...
  static const String home = '/';
  static const String newPage = '/newsPage';
  static const String newsDetail = '/newPage/detail';
  static const String crypto = '/cryptoPage';
  static const String account = '/newPage/accountPage';
  static const String cryptoSearch = '/cryptoPage/search';
  static const String cryptochart = '/cryptoPage/cryptochart';

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
      case cryptoSearch:
        if (args is String) {
          // 將參數傳遞給NewsDetail頁面
          return MaterialPageRoute(builder: (_) => CryptoSearchPage(args));
        }
        return _errorRoute();
      case account:
        // return MaterialPageRoute(builder: (_) => const HomePage());
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => AuthenticationBloc(),
                child: const AccountPage()));

      case cryptochart:
        return MaterialPageRoute(builder: (_) => const LineChartSample2());

      case crypto:
      // return MaterialPageRoute(builder: (_) => const BinanceWebSocket());
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
