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
  CryptoCycleTime cycleType = CryptoCycleTime.oneDay;
  late List<SelectTimeCycle> _selectTimeCycle;
  bool touchPrice = false;
  String show = '';
  double maxPrice = 0;
  double maxdate = 0;

  Map<CryptoCycleTime, List<ChartData>> dataResult = {};

  final String cryptoSymbol = 'bitcoin';
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    debugPrint('${data.length} value在這');

    var timeFormatMap = {
      CryptoCycleTime.oneDay: data[value.toInt() - 1].date.hour,
      CryptoCycleTime.threeMonth: data[value.toInt() - 1].date.month,
      CryptoCycleTime.sixMonth: data[value.toInt() - 1].date.month,
    };
    return Text(
        '${timeFormatMap[cycleType] ?? data[value.toInt() - 1].date.day}');
  }

  @override
  Widget build(BuildContext context) {
    final lastprice = data.last.price.toStringAsFixed(4);
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
                            flex: 2,
                            child: Container(
                              // color: Colors.yellow,
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              height: double.maxFinite,
                              child: const Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      textContent: 'BTC-USD',
                                      align: TextAlign.left,
                                      fontSize: 34,
                                      textColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Flexible(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              // alignment: Alignment.bottomLeft,
                              color: Colors.white,
                              // width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    color: Colors.blueGrey,
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      textContent: 'USD \$$lastprice',
                                      // textColor: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.green,
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      textContent:
                                          'Volume ${data.last.volumes.toInt()}',
                                      textColor: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
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
                                          cycleType =
                                              CryptoCycleTime.values[index];
                                          setState(() {
                                            data = dataResult[
                                                CryptoCycleTime.values[index]]!;
                                          });
                                          // fetchMarketData(cryptoSymbol,
                                          //     _selectTimeCycle[index].timeType);
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
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              child: LineChart(
                                mainData(),
                              ),
                            ))
                      ],
                    ))),
    );
  }

  /////選取要顯示哪個時段週期
  List<int> calculateTimestamps(CryptoCycleTime cycleTime) {
    final DateTime now = DateTime.now();
    final int nowMilliseconds = now.millisecondsSinceEpoch ~/ 1000;

    int daysToSubtract;
    switch (cycleTime) {
      case CryptoCycleTime.oneDay:
        daysToSubtract = 1;
        break;
      case CryptoCycleTime.oneWeek:
        daysToSubtract = 7;
        break;
      case CryptoCycleTime.oneMonth:
        daysToSubtract = 30;
        break;
      case CryptoCycleTime.threeMonth:
        daysToSubtract = 90;
        break;
      case CryptoCycleTime.sixMonth:
        daysToSubtract = 180;
        break;
      default:
        return [];
    }

    final int toTimestamp = nowMilliseconds;
    final int fromTimestamp = nowMilliseconds - (daysToSubtract * 86400);
    return [fromTimestamp, toTimestamp];
  }

  Future<void> downloadApis() async {
    // fetchSaveMarketData(cryptoSymbol, CryptoCycleTime.oneDay);
    fetchSaveMarketData(cryptoSymbol, CryptoCycleTime.oneWeek);
    fetchSaveMarketData(cryptoSymbol, CryptoCycleTime.oneMonth);
    fetchSaveMarketData(cryptoSymbol, CryptoCycleTime.threeMonth);
    fetchSaveMarketData(cryptoSymbol, CryptoCycleTime.sixMonth);

    // for (var cycleTime in CryptoCycleTime.values) {
    //   fetchSaveMarketData(
    //       cryptoSymbol, cycleTime); // Replace 'symbol' with the actual symbol
    // }

    debugPrint("${dataResult.keys}dataResult.toString()");
  }

  //回傳週期api資料
  Future<void> fetchMarketData(String symbol, CryptoCycleTime cycleTime) async {
    cycleType = cycleTime;
    final timeList = calculateTimestamps(cycleTime);

    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/$symbol/market_chart/range?vs_currency=usd&from=${timeList[0]}&to=${timeList[1]}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body)['prices'];
      final List<dynamic> resultVolumes =
          jsonDecode(response.body)['total_volumes'];

      data = result
          .asMap()
          .entries
          .map((entry) => ChartData(
              DateTime.fromMillisecondsSinceEpoch(entry.value[0].toInt()),
              entry.value[1],
              resultVolumes[entry.key][1] ?? 0)) // entry.key is the index
          .toList();
      dataResult[cycleTime] = data;
      setState(() {});
    } else {
      throw Exception('Failed to fetch market data');
    }
  }

  Future<void> fetchSaveMarketData(
      String symbol, CryptoCycleTime cycleTime) async {
    final timeList = calculateTimestamps(cycleTime);

    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/$symbol/market_chart/range?vs_currency=usd&from=${timeList[0]}&to=${timeList[1]}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> result = jsonDecode(response.body)['prices'];
      final List<dynamic> resultVolumes =
          jsonDecode(response.body)['total_volumes'];

      dataResult[cycleTime] = result
          .asMap()
          .entries
          .map((entry) => ChartData(
              DateTime.fromMillisecondsSinceEpoch(entry.value[0].toInt()),
              entry.value[1],
              resultVolumes[entry.key][1] ?? 0)) // entry.key is the index
          .toList();
      debugPrint("${dataResult[cycleTime]}${cycleTime.name}");
      // setState(() {});
    } else {
      throw Exception('Failed to fetch market data');
    }
  }

  FlTitlesData getFlTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
            showTitles: true, reservedSize: 50, interval: getYtimeArea() / 2.5
            // getTitlesWidget: rightTitleWidgets
            ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          interval: getXtimeArea(),
          reservedSize: 40,
          showTitles: true,
          getTitlesWidget: bottomTitleWidgets,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  LineTouchData getLineTouchData() {
    return LineTouchData(
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
        fitInsideHorizontally: true,
        fitInsideVertically: true,
      ),
      getTouchedSpotIndicator:
          (LineChartBarData barData, List<int> spotIndexes) {
        return spotIndexes.map((spotIndex) {
          return TouchedSpotIndicatorData(
            FlLine(color: Colors.black, strokeWidth: 2),
            FlDotData(
              show: false,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 8,
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
        final List<TouchLineBarSpot>? spots = p1!.lineBarSpots;
        final spot = spots?.first;
        final x = spot?.x;
        final time = data[x!.toInt() - 1].date;

        if (cycleType == CryptoCycleTime.oneDay ||
            cycleType == CryptoCycleTime.oneWeek) {
          show =
              '${time.year}年${time.month}月${time.day}日${time.hour}時${time.second}分';
        } else {
          show = '${time.year}年' '${time.month}月${time.day}日';
        }

        setState(() {});
      },
    );
  }

  double getXtimeArea() {
    Map<CryptoCycleTime, double> cycleTimeToArea = {
      CryptoCycleTime.oneDay: 48,
      CryptoCycleTime.oneWeek: 48,
      CryptoCycleTime.oneMonth: 168,
      CryptoCycleTime.threeMonth: 31,
      CryptoCycleTime.sixMonth: 62,
    };

    return cycleTimeToArea[cycleType]!;
  }

  double getYtimeArea() {
    final minPriceData = data.reduce(
        (value, element) => value.price < element.price ? value : element);
    final maxPriceData = data.reduce(
        (value, element) => value.price > element.price ? value : element);

    maxPrice = maxPriceData.price - minPriceData.price;

    return maxPrice;
  }

  @override
  void initState() {
    super.initState();
    _selectTimeCycle = SelectTimeCycle.selectTimeCycleData;
// apidae bitcoin

    fetchMarketData(cryptoSymbol, CryptoCycleTime.oneDay);
    downloadApis();
    // for (var cycleTime in CryptoCycleTime.values) {
    //   fetchSaveMarketData(
    //       cryptoSymbol, cycleTime); // Replace 'symbol' with the actual symbol
    // }

    // if (dataResult[cycleType] != null) {
    //   data = dataResult[cycleType]!;
    // }
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: getLineTouchData(),
      titlesData: getFlTitlesData(),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Colors.white),
      ),
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

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    // debugPrint('${data.length} right Title value在這');
    final minPriceData = data.reduce(
        (value, element) => value.price < element.price ? value : element);
    final maxPriceData = data.reduce(
        (value, element) => value.price > element.price ? value : element);

    maxPrice = maxPriceData.price - minPriceData.price;
    return Text('$value');
  }
}
