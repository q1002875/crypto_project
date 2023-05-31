import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChartData {
  final DateTime date;
  final double price;
  final double dateMilliseconds; // 新增字段

  ChartData(this.date, this.price)
      : dateMilliseconds =
            date.millisecondsSinceEpoch.toDouble(); // 在构造函数里转换日期为时间戳
}

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [Colors.red, Colors.redAccent];
  late List<ChartData> data = [];
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
    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
            flex: 2,
            child: Center(
              child: Text(show),
            )),
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10),
              child: LineChart(
                mainData(),
              ),
            ))
      ],
    );
  }

  Future<void> fetchMarketData(int selectDay) async {
    final fromDate = DateTime(2023, 5, 1);
    final toDate = DateTime(2023, 5, 30);

    final fromTimestamp = fromDate.millisecondsSinceEpoch ~/ 1000;
    final toTimestamp = toDate.millisecondsSinceEpoch ~/ 1000;

    final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/bitcoin/market_chart/range?vs_currency=usd&from=$fromTimestamp&to=$toTimestamp');
    // final url = Uri.parse(
    // 'https://api.coingecko.com/api/v3/coins/bitcoin/market_chart/range?vs_currency=usd&from=1672406400&to=1674988800');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body)['prices'];
      data = result.map((item) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(item[0].toInt());
        double price = item[1];
        return ChartData(date, price);
      }).toList();

      maxdate = data
              .reduce((max, e) =>
                  e.dateMilliseconds > max.dateMilliseconds ? e : max)
              .dateMilliseconds -
          data
              .reduce((min, e) =>
                  e.dateMilliseconds < min.dateMilliseconds ? e : min)
              .dateMilliseconds;

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
    // TODO: implement initState
    super.initState();
    fetchMarketData(30);
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
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

          setState(() {
            show = '${data[x.toInt() - 1].date.month}月'
                '${data[x.toInt() - 1].date.day}日'
                '${data[x.toInt() - 1].date.hour}時';
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
