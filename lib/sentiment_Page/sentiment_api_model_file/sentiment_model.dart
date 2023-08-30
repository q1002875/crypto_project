import '../../common.dart';

Map getSentimentLevel(int value) {
  if (value >= 0 && value <= 25) {
    return {'level': 'Extreme Fear', 'color': Colors.red};
  } else if (value >= 26 && value <= 44) {
    return {'level': 'Fear', 'color': Colors.orange};
  } else if (value >= 45 && value <= 55) {
    return {
      'level': 'Neutral',
      'color': const Color.fromARGB(255, 224, 192, 51)
    };
  } else if (value >= 56 && value <= 74) {
    return {'level': 'Greed', 'color': const Color.fromARGB(255, 138, 221, 56)};
  } else if (value >= 75 && value <= 100) {
    return {'level': 'Extreme Greed', 'color': Colors.green};
  } else {
    return {
      'level': 'Invalid input',
      'color': const Color.fromARGB(255, 14, 234, 65)
    };
  }
}

class FearGreedIndex {
  static List<String> daytitle = [
    'Now',
    'Yesterday',
    'Last Week',
    'Last Month'
  ];
  String value;
  String valueClassification;
  DateTime timestamp;

  // String timeUntilUpdate;

  FearGreedIndex({
    required this.value,
    required this.valueClassification,
    required this.timestamp,
    // required this.timeUntilUpdate,
  });

  factory FearGreedIndex.fromJson(Map<String, dynamic> json) {
    final timestamp = json['timestamp'];
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
    // final formattedDate = DateFormat('yyyy-MM-dd HH').format(dateTime);

    return FearGreedIndex(
        value: json['value'],
        valueClassification: json['value_classification'],
        timestamp: dateTime
        // timeUntilUpdate: json['time_until_update'],
        );
  }
}

// ignore: camel_case_types
class selectSentimentDayRange {
  static List<selectSentimentDayRange> selectSentimentData = [
    selectSentimentDayRange(select: true, timeTitle: '7'),
    selectSentimentDayRange(select: false, timeTitle: '30')
  ];

  String timeTitle;
  bool select;
  selectSentimentDayRange({this.select = false, this.timeTitle = ""});
}
