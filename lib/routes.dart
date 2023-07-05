import 'package:crypto_project/account_Page/account_about.dart';
import 'package:crypto_project/account_Page/account_privacy.dart';
import 'package:crypto_project/account_Page/login/bloc/login_bloc.dart';
import 'package:crypto_project/crypto_Page/crypto_search_page.dart';
import 'package:crypto_project/news_Page_view/news_cell_detail.dart';

import 'account_Page/account_view.dart';
import 'api_model/news_totalModel.dart';
import 'bloc/bloc/news_Bloc/news_bloc.dart';
import 'common.dart';
import 'crypto_Page/crypto_detail_chart.dart';
import 'crypto_Page/crypto_view_page.dart';
import 'news_Page_view/news_view.dart';
import 'service_Api/news_api.dart';

class ChartArguments {
  final List<SymbolCase> trickcrypto;
  final String userid;

  ChartArguments(this.trickcrypto, this.userid);
}

class Routes {
  static const String home = '/';
  static const String newPage = '/newsPage';
  static const String newsDetail = '/newPage/detail';
  static const String crypto = '/cryptoPage';
  static const String account = '/newPage/accountPage';
  static const String cryptoSearch = '/cryptoPage/search';
  static const String cryptochart = '/cryptoPage/cryptochart';
  static const String accoundAbout = '/newPage/accountPage/about';
  static const String accountPrivacy = '/newPage/accountPage/privacy';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case home:
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
          return MaterialPageRoute(builder: (_) => NewsDetail(news: args));
        }
        return _errorRoute();
      case cryptoSearch:
        if (args is String) {
          return MaterialPageRoute(builder: (_) => CryptoSearchPage(args));
        }
        return _errorRoute();
      case account:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => AuthenticationBloc(),
                child: AccountPage()));

      case cryptochart:
        if (args is Trickcrypto) {
          return MaterialPageRoute(builder: (_) => LineChartPage(args));
        }
        return _errorRoute();
      case accountPrivacy:
        return MaterialPageRoute(builder: (_) => const AccountPrivacy());
      case accoundAbout:
        return MaterialPageRoute(builder: (_) => const AccoundAbout());
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
