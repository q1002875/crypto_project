class ChartData {
  final DateTime date;
  final double price;
  final double dateMilliseconds; // 新增字段
  final double volumes;
  ChartData(this.date, this.price, this.volumes)
      : dateMilliseconds =
            date.millisecondsSinceEpoch.toDouble(); // 在构造函数里转换日期为时间戳
}

enum CryptoCycleTime {
  oneDay,
  oneWeek,
  oneMonth,
  threeMonth,
  sixMonth,
}

class SelectTimeCycle {
  static List<SelectTimeCycle> selectTimeCycleData = [
    SelectTimeCycle(
        timeType: CryptoCycleTime.oneDay, timeTitle: 'Day', select: true),
    SelectTimeCycle(
        timeType: CryptoCycleTime.oneWeek, timeTitle: 'Week', select: false),
    SelectTimeCycle(
        timeType: CryptoCycleTime.oneMonth, timeTitle: 'Month', select: false),
    SelectTimeCycle(
        timeType: CryptoCycleTime.threeMonth,
        timeTitle: '3Months',
        select: false),
    SelectTimeCycle(
        timeType: CryptoCycleTime.sixMonth,
        timeTitle: '6Months',
        select: false),
  ];
  CryptoCycleTime timeType;
  String timeTitle;
  bool select;
  SelectTimeCycle(
      {this.timeType = CryptoCycleTime.oneDay,
      this.timeTitle = '',
      this.select = false});
}
