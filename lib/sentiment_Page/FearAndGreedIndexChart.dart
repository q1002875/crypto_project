import 'package:crypto_project/extension/ShimmerText.dart';
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    ///這裡直接資料顛倒對調
    final dataLength = widget.data.length - value.toInt() - 1;
    final month = widget.data[dataLength].date.month;
    final resultDay = widget.data[dataLength].date.day;
    final resultText = '$month/$resultDay';
    return Text(resultText);
  }

////主畫面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Fear and Greed Index Chart'),
      // ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(20.0),
        child: _buildChart(),
      ),
    );
  }

  ///當進入的資料有變化時改變畫面 適用於future 之後的資料載入
  @override
  void didUpdateWidget(FearAndGreedIndexChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      var list = widget.data.toList();
      list = list.reversed.toList();
      _dataList = list;
      setState(() {});
    }
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
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.orange[400],
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                // final x = barSpot.x;
                final y = barSpot.y;
                return y < 50
                    ? LineTooltipItem(
                        'Fear',
                        const TextStyle(color: Colors.white),
                      )
                    : LineTooltipItem(
                        'Greed',
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
          drawVerticalLine: true,
          horizontalInterval: 5.0,
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
              interval: widget.data.length > 20 ? 3 : 1,
              reservedSize: 20,
              showTitles: true,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles:
                SideTitles(reservedSize: 50, interval: 3, showTitles: true),
          ),
        ),
        //框架線條設定區
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 3.0),
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
