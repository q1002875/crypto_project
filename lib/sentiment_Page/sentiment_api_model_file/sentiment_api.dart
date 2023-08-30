import 'package:crypto_project/sentiment_Page/FearAndGreedIndexChart.dart';
import 'package:crypto_project/sentiment_Page/sentiment_api_model_file/sentiment_model.dart';

import '../../common.dart' as http;
import '../../common.dart';

class SentimentApi {
  static Future<List<FearGreedIndex>> fetchFearGreedIndex(
      String timeSpan) async {
    final url = Uri.parse('https://api.alternative.me/fng/?limit=$timeSpan');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => FearGreedIndex.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  static Future<List<FearAndGreedData>> getSentimentData(
      String selectday) async {
    // _dataList.clear();
    var url = Uri.parse('https://api.alternative.me/fng/?limit=$selectday');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];
      List<FearAndGreedData> dataList = [];

      for (var item in jsonData) {
        var timestamp = item['timestamp'];
        final parint = int.parse(timestamp);
        var value = item['value'];
        var classification = item['value_classification'];
        var date = DateTime.fromMillisecondsSinceEpoch(parint * 1000);
        dataList.add(FearAndGreedData(date, value, classification));
      }
      return dataList;
    } else {
      ////拋出問題就不用 ?檢查
      throw Exception('Failed to fetch data');
      // print('Request failed with status: ${response.statusCode}.');
    }
  }
}
