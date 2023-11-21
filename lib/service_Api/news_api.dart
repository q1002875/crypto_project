// ignore: camel_case_types

import 'package:crypto_project/api_model/news_totalModel.dart';

import '../http_server.dart';

//test change 2

// ignore: camel_case_types
class newsApi {
  final authkey = 'ad81416ef1cc039a1b772abe6f8f62eb';
  final authkey2 = 'c12c324dfd67bb1e97dbb9787757fef8';
//  String newUrl = 'https://gnews.io/api/v4/search?q=crypto&lang=en&country=us&max=10&apikey=$authkey';

  Future<List<ArticleModel>> getArticleReport(String search) async {
    final api =
        'https://gnews.io/api/v4/search?q=$search&lang=en&country=us&max=10&apikey=$authkey';
    final data = httpService(baseUrl: api);
    final response = await data.getJson();
    final jsonMap = NewsModel.fromJson(response);
    return jsonMap.articles;
  }
}


///final運行時
///const編譯時