class FearGreedIndex {
  String value;
  String valueClassification;
  String timestamp;
  String timeUntilUpdate;

  FearGreedIndex({
    required this.value,
    required this.valueClassification,
    required this.timestamp,
    required this.timeUntilUpdate,
  });

  factory FearGreedIndex.fromJson(Map<String, dynamic> json) {
    return FearGreedIndex(
      value: json['value'],
      valueClassification: json['value_classification'],
      timestamp: json['timestamp'],
      timeUntilUpdate: json['time_until_update'],
    );
  }
}
