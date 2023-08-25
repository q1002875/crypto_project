import 'package:crypto_project/extension/ShimmerText.dart';
import 'package:crypto_project/extension/custom_text.dart';
import 'package:crypto_project/extension/gobal.dart';
import 'package:fl_chart/fl_chart.dart';

import '../common.dart';

class FearAndGreedData {
  DateTime date;
  String value;
  String classification;

  FearAndGreedData(this.date, this.value, this.classification);
}

// ignore: must_be_immutable
class FearAndGreedIndexChart extends StatefulWidget {
  List<FearAndGreedData> data;
  FearAndGreedIndexChart(this.data, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FearAndGreedIndexChartState createState() => _FearAndGreedIndexChartState();
}

class _FearAndGreedIndexChartState extends State<FearAndGreedIndexChart> {
  List<FearAndGreedData> _dataList = [];
  var selectTitle = '';
  var selectTitleColor = Colors.black;
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    ///這裡直接資料顛倒對調
    final dataLength = widget.data.length - value.toInt() - 1;
    final month = widget.data[dataLength].date.month;
    final resultDay = widget.data[dataLength].date.day;
    final resultText = '$month/$resultDay';
    return CustomText(
        textContent: resultText, fontSize: 12, textColor: Colors.black);
  }

  ////主畫面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Fear and Greed Index Chart'),
        // ),
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
            flex: 1,
            child: CustomText(
              textContent: selectTitle,
              textColor: selectTitleColor,
              fontSize: 19,
            )),
        Flexible(
          flex: 9,
          child: Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(20.0),
            child: _buildChart(),
          ),
        )
      ],
    ));
  }

  ///當進入的資料有變化時改變畫面 適用於future 之後的資料載入
  @override
  void didUpdateWidget(FearAndGreedIndexChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      setState(() {
        _dataList = widget.data;
      });
    }
  }

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
      return {
        'level': 'Greed',
        'color': const Color.fromARGB(255, 138, 221, 56)
      };
    } else if (value >= 75 && value <= 100) {
      return {'level': 'Extreme Greed', 'color': Colors.green};
    } else {
      return {
        'level': 'Invalid input',
        'color': const Color.fromARGB(255, 14, 234, 65)
      };
    }
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    ///這裡直接資料顛倒對調
    final text = value.toInt();
    return CustomText(
        textContent: '$text', fontSize: 12, textColor: Colors.black);
  }

  void setTitleValue(String value) {
    setState(() {
      selectTitle = value;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _dataList = widget.data;deee
  // }
////分割小畫面折線圖部分
  Widget _buildChart() {
    if (_dataList.isEmpty) {
      return Center(
          child: ShimmerBox(
        width: screenWidth,
        height: screenHeight / 2,
      ));
    }

    List<FlSpot> spots = [];
    for (var i = 0; i < _dataList.length; i++) {
      spots.add(FlSpot(i.toDouble(), double.parse(_dataList[i].value)));
    }

    return LineChart(
      LineChartData(
        ////觸碰顯示設定區
        lineTouchData: LineTouchData(
          enabled: true,
          touchCallback: (p0, p1) {
            final List<TouchLineBarSpot>? spots = p1!.lineBarSpots;
            final spot = spots?.first;
            final x = spot?.x;
            final time = _dataList[_dataList.length - x!.toInt() - 1].date;
            final value = _dataList[x.toInt() - 1].value;
            final getgetSentimentLevelModel =
                getSentimentLevel(int.parse(value));
            final level = getgetSentimentLevelModel['level'];
            final color = getgetSentimentLevelModel['color'];
            setState(() {
              selectTitle = '${time.year}/${time.month}/${time.day}($level)';
              selectTitleColor = color;
            });
          },
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.orange[400],
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              // setTitleValue('sss');
              return touchedBarSpots.map((barSpot) {
                // final x = barSpot.x;

                final y = barSpot.y;
                final setmetint = '${y.toInt()}';
                return LineTooltipItem(
                  setmetint,
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),

        /////網格設定區
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: 2.0,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey,
              strokeWidth: 1.0,
            );
          },
        ),
        /////下方及右方顯示軸設定區
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: widget.data.length > 20 ? 5 : 1,
              reservedSize: 20,
              showTitles: true,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 3,
              reservedSize: 30,
              showTitles: true,
              getTitlesWidget: leftTitleWidgets,
            ),
          ),
        ),
        //框架線條設定區
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.grey, width: 3.0),
            left: BorderSide(color: Colors.grey, width: 3.0),
          ),
        ),

        ////數值線條設定區
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: Colors.orange[400],
            barWidth: 3.0,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  // String _formatDate(DateTime date) {
  //   return '${date.year}-${date.month}-${date.day}';
  // }
}
