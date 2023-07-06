import 'package:http/http.dart' as http;

import '../common.dart';

class SentimentApi {
  Future<dynamic> _loadFearGreedIndexHistory(String timeSpan) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.alternative.me/fng/?limit=30&timeframe=$timeSpan'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final historyData = json['data'];
        return historyData;
        // setState(() {
        //   _historyData = historyData;
        // });
      } else {
        throw Exception('Failed to load fear and greed index history');
      }
    } catch (e) {
      print(e);
    }
  }
}
