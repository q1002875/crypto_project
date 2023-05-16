import '../http_server.dart';

class coinbaseApi {

 static Future<String> getcoinBaseImageReport() async {
  
    final data = httpService(baseUrl: 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol=ETH&CMC_PRO_API_KEY=6e35c3bf-1346-4a87-9bae-25fe6ea51136');
    final response = await data.getJson();
    print(response.body);
    // final jsonMap = NewsModel.fromJson(response);
    return response.body;
  }
}
