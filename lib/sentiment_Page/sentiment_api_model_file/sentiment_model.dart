class FearGreedIndex {
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
