import 'package:crypto_project/home_page_view/news_cell_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'api_model/news_totalModel.dart';
import 'bloc/bloc/news_Bloc/news_bloc.dart';
import 'home_page_view/news_view.dart';
import 'news_api.dart';

class Routes {
  // ...
  static const String home = '/';
  static const String newPage = '/newsPage';
  static const String newsDetail = '/newPage/detail';

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
