import 'package:crypto_project/sentiment_Page/sentiment_api_model_file/sentiment_model.dart';

import '../../common.dart' as http;
import '../../common.dart';

/////完整api
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
}
