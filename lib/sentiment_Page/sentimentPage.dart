import 'package:crypto_project/extension/custom_text.dart';
import 'package:crypto_project/sentiment_Page/sentiment_api.dart';
import 'package:http/http.dart' as http;

import '../common.dart';

class DashboardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  // final Widget content;

  const DashboardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    // required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 16.0),
          // content,
        ],
      ),
    );
  }
}

///////上面儀表板
/////////
// ignore: camel_case_types
class sentimentPage extends StatefulWidget {
  const sentimentPage({super.key});

  @override
  State<sentimentPage> createState() => _sentimentPageState();
}

// ignore: camel_case_types
class _sentimentPageState extends State<sentimentPage> {
  // String _fearGreedIndex = '';
  // final List<dynamic> _historyData = [];
  late final SentimentApi sentiment;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.blueGrey,
          child: const Column(
            children: [
              CustomText(
                textContent: 'Crypto Market \n Fear&Greed',
                fontSize: 26,
                textColor: Colors.white,
              ),
              // SizedBox(height: 16),
              // Text(
              //   'Latest Index: $_fearGreedIndex',
              //   style: const TextStyle(fontSize: 18, color: Colors.white),
              // ),
            ],
          ),
        ),
        const Expanded(
            child: DashboardWidget(
          subtitle: 'ddd',
          title: 'ssss',
        )),
      ],
    );
  }

  Future<void> fetchData() async {
    try {
      await sentiment._la;
      // 在此處處理獲取到的資料
    } catch (e) {
      // 處理錯誤
    }
  }

  @override
  void initState() {
    super.initState();
    sentiment = SentimentApi();
    _loadFearGreedIndex();
    fetchData();
    // _loadFearGreedIndexHistory('30d');
  }

  Future<void> _loadFearGreedIndex() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.alternative.me/fng/?limit=1'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final fearGreedIndex = json['data'][0]['value'];
        setState(() {
          _fearGreedIndex = fearGreedIndex.toString();
        });
      } else {
        throw Exception('Failed to load fear and greed index');
      }
    } catch (e) {
      print(e);
    }
  }
}
