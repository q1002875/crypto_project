import 'dart:convert';

import 'package:crypto_project/extension/gobal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../extension/custom_text.dart';

class ChartData {
  final DateTime date;
  final double price;
  final double dateMilliseconds; // 新增字段

  ChartData(this.date, this.price)
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

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
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

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [Colors.red, Colors.redAccent];
  List<ChartData> data = [];
  // ignore: prefer_final_fields
  late List<SelectTimeCycle> _selectTimeCycle;
  bool touchPrice = false;
  String show = '';
  double maxPrice = 0;
  double maxdate = 0;
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    print('${data.length} value在這');

    //value 是index來看

    //  var date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    //     return DateFormat.yMd().format(date);  // 你可以根据需求改变日期格式
    DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    // String dateString = DateFormat.yMd().format(date); // 依你所需的日期格式自行修改
    return Text('${data[value.toInt() - 1].date.day}');
    // const style = TextStyle(
    //   fontWeight: FontWeight.bold,
    //   fontSize: 16,
    // );
    // Widget text;
    // text = Text('${value.toInt()}');
    // // switch (value.toInt()) {}

    // return SideTitleWidget(
    //   axisSide: meta.axisSide,
    //   child: text,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back), // set your color here
                onPressed: () => Navigator.pop(context),
              ),
              title: const CustomText(
                textContent: 'BTC Price',
                textColor: Colors.white,
              )),
          body: Container(
              color: Colors.white,
              child: data == []
                  ? const CircularProgressIndicator()
                  : Flex(
                      direction: Axis.vertical,
                      children: [
                        Flexible(
                            flex: 1,
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              height: double.maxFinite,
                              child: const CustomText(
                                textContent: 'BTC-USD',
                                align: TextAlign.left,
                                fontSize: 24,
                                textColor: Colors.black,
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              alignment: Alignment.bottomLeft,
                              color: Colors.pink,
                              width: double.infinity,
                              height: double.maxFinite,
                              child: Column(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    align: TextAlign.left,
                                    textContent:
                                        'US\$${data.last.price.toStringAsFixed(4)}',
                                    textColor: Colors.black,
                                    fontSize: 18,
                                  ),
                                  const CustomText(
                                    align: TextAlign.left,
                                    textContent: 'usd',
                                    textColor: Colors.grey,
                                    fontSize: 16,
                                  )
                                ],
                              ),
                            )),
                        Flexible(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(left: 3),
                              color: Colors.white,
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 8.0),
                                scrollDirection: Axis.horizontal,
                                itemCount: _selectTimeCycle.length,
                                itemBuilder: (context, index) {
                                  // List<HeaderTopic> topicList = _headerTopic.resultData;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: InkWell(
                                        onTap: () {
                                          for (var i = 0;
                                              i < _selectTimeCycle.length;
                                              i++) {
                                            if (i == index) {
                                              _selectTimeCycle[i].select = true;
                                            } else {
                                              _selectTimeCycle[i].select =
                                                  false;
                                            }
                                          }
                                          fetchMarketData(
                                              _selectTimeCycle[index].timeType);
                                        },
                                        child: _selectTimeCycle[index].select
                                            ? Container(
                                                width: screenWidth / 3,
                                                height: screenWidth / 10,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(
                                                      0.5), // Light red color
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0), // Circular border
                                                ),
                                                child: CustomText(
                                                  align: TextAlign.center,
                                                  textContent:
                                                      _selectTimeCycle[index]
                                                          .timeTitle,
                                                  textColor:
                                                      const Color.fromARGB(
                                                          255, 49, 39, 38),
                                                ),
                                              )
                                            : Container(
                                                alignment: Alignment.centerLeft,
                                                child: CustomText(
                                                  textContent:
                                                      _selectTimeCycle[index]
                                                          .timeTitle,
                                                  textColor: Colors.grey,
                                                ),
                                              )),
                                  );
                                },
                              ),
                            )),
                        Flexible(
                            flex: 1,
                            child: Center(
                              child: CustomText(
                                textContent: show,
                                textColor: Colors.black,
                                fontSize: 16,
                              ),
                            )),
                        Expanded(
                            flex: 9,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 10),
                              child: LineChart(
                                mainData(),
                              ),
                            ))
                      ],
                    ))),
    );
  }

  List<int> calculateTimestamps(CryptoCycleTime cycleTime) {
    final DateTime now = DateTime.now();
    final int nowMilliseconds = now.millisecondsSinceEpoch ~/ 1000;

    switch (cycleTime) {
      case CryptoCycleTime.oneDay:
        final int toTimestamp = nowMilliseconds;
        final int fromTimestamp = toTimestamp - 86400;
        return [fromTimestamp, toTimestamp];

      case CryptoCycleTime.oneWeek:
        final int toTimestamp = nowMilliseconds;
        final int fromTimestamp = toTimestamp - 86400 * 7;
        return [fromTimestamp, toTimestamp];

      case CryptoCycleTime.oneMonth:
        final DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
        final int nowMilliseconds = now.millisecondsSinceEpoch ~/ 1000;
        final int toTimestamp = nowMilliseconds;
        final int fromTimestamp = oneMonthAgo.millisecondsSinceEpoch ~/ 1000;
        return [fromTimestamp, toTimestamp];

      case CryptoCycleTime.threeMonth:
        final DateTime threeMonthsAgo =
            DateTime(now.year, now.month - 3, now.day);
        final int nowMilliseconds = now.millisecondsSinceEpoch ~/ 1000;
        final int toTimestamp = nowMilliseconds;
        final int fromTimestamp = threeMonthsAgo.millisecondsSinceEpoch ~/ 1000;
        return [fromTimestamp, toTimestamp];

      case CryptoCycleTime.sixMonth:
        final DateTime sixMonthsAgo =
            DateTime(now.year, now.month - 6, now.day);
        final int nowMilliseconds = now.millisecondsSinceEpoch ~/ 1000;
        final int toTimestamp = nowMilliseconds;
        final int fromTimestamp = sixMonthsAgo.millisecondsSinceEpoch ~/ 1000;
        return [fromTimestamp, toTimestamp];

      default:
        return [];
    }
  }

  Future<void> fetchMarketData(CryptoCycleTime cycleTime) async {
    final timeList = calculateTimestamps(cycleTime);
    final fromTimestamp = timeList[0];
    final toTimestamp = timeList[1];

    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/bitcoin/market_chart/range?vs_currency=usd&from=$fromTimestamp&to=$toTimestamp');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body)['prices'];
      data = result.map((item) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(item[0].toInt());
        double price = item[1];
        return ChartData(date, price);
      }).toList();

      // maxdate = data
      //         .reduce((max, e) =>
      //             e.dateMilliseconds > max.dateMilliseconds ? e : max)
      //         .dateMilliseconds -
      //     data
      //         .reduce((min, e) =>
      //             e.dateMilliseconds < min.dateMilliseconds ? e : min)
      //         .dateMilliseconds;

      ///用最大扣最小取得區間
      maxPrice = data
              .reduce((value, element) =>
                  value.price > element.price ? value : element)
              .price -
          data
              .reduce((value, element) =>
                  value.price < element.price ? value : element)
              .price;
      debugPrint(data[0].date.toString());
      setState(() {});
    } else {
      throw Exception('Failed to fetch market data');
    }
  }

  @override
  void initState() {
    super.initState();
    _selectTimeCycle = SelectTimeCycle.selectTimeCycleData;

    fetchMarketData(CryptoCycleTime.oneDay);
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        ///提示框
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.red[700],
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              const TextStyle textStyle = TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return LineTooltipItem(
                '${touchedSpot.y}',
                textStyle,
              );
            }).toList();
          },
          //提示框固定在範圍內
          fitInsideHorizontally: true,
          fitInsideVertically: true,
        ),

        ///那條線
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.black, strokeWidth: 2),
              FlDotData(
                show: false,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 8, // Change to desired size
                  color: Colors.red,
                  strokeWidth: 3,
                  strokeColor: Colors.white,
                ),
              ),
            );
          }).toList();
        },
        enabled: true,
        touchCallback: (p0, p1) {
          // 当用户触摸图表时，获取数据并执行一些操作
          final List<TouchLineBarSpot>? spots = p1!.lineBarSpots;
          final spot = spots?.first;
          // final value = spot?.y;
          // final index = spot?.barIndex;
          final x = spot?.x; // 获取所选数据的 x 坐标
          // 在这里执行显示 x 坐标的操作
          print('${data[x!.toInt() - 1].date.month}月'
              '${data[x.toInt() - 1].date.day}日'
              '${data[x.toInt() - 1].date.hour}時');

          final time = data[x.toInt() - 1].date;
          setState(() {
            show = '${time.month}月'
                '${time.day}日'
                '${time.hour}時'
                '${time.second}分';
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true, reservedSize: 50, interval: maxPrice / 2.5),
        ),

        // AxisTitles(
        //   sideTitles: SideTitles(
        //       showTitles: true,
        //       interval: 1,
        //       getTitlesWidget: rightTitleWidgets,
        //       reservedSize: 30),
        // ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),

        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 40,
            showTitles: true,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Colors.white),
      ),
      // minX: data
      //     .reduce((min, e) => e.date.day < min.date.day ? e : min)
      //     .date
      //     .day
      //     .toDouble(),
      // maxX: data
      //     .reduce((max, e) => e.date.day > max.date.day ? e : max)
      //     .date
      //     .day
      //     .toDouble(),
      minX: 1,
      maxX: data.length.toDouble(),
      minY: data
          .reduce(
              (value, element) => value.price < element.price ? value : element)
          .price,
      maxY: data
          .reduce(
              (value, element) => value.price > element.price ? value : element)
          .price,
      lineBarsData: [
        LineChartBarData(
          spots: data
              .asMap()
              .entries
              .map((entry) =>
                  FlSpot(entry.key.toDouble(), entry.value.price.toDouble()))
              .toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Widget rightTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     // fontWeight: FontWeight.bold,
  //     fontSize: 5,
  //   );
  //   String text;
  //   // text = '${value.toInt()}';
  //   if (value >= 20000 && value <= 25000) {
  //     text = '20k-25k';
  //   } else if (value > 25000 && value <= 30000) {
  //     text = '25k-30k';
  //   } else if (value > 30000 && value <= 50000) {
  //     text = '30k-50k';
  //   } else {
  //     return Container();
  //   }

  //   return Text(text, style: style, textAlign: TextAlign.left);
  // }
}
