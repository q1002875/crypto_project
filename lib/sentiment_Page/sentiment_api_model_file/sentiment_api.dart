import 'package:crypto_project/sentiment_Page/sentiment_api_model_file/sentiment_model.dart';

import '../../common.dart' as http;
import '../../common.dart';

/////完整api
class SentimentApi {
  static Future<FearGreedIndex> fetchFearGreedIndex(String timeSpan) async {
    final url = Uri.parse(
        'https://api.alternative.me/fng/?limit=30&timeframe=$timeSpan');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['data'] as List<dynamic>;

      if (data.isNotEmpty) {
        final firstItem = data.first;
        return FearGreedIndex.fromJson(firstItem);
      }
    }
    throw Exception('Failed to fetch Fear and Greed Index');
  }
}
