import 'package:crypto_project/extension/ShimmerText.dart';
import 'package:crypto_project/extension/custom_text.dart';
import 'package:crypto_project/extension/gobal.dart';
import 'package:crypto_project/sentiment_Page/bloc/sentiment_bloc.dart';
import 'package:crypto_project/sentiment_Page/sentiment_api_model_file/sentiment_model.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

import '../common.dart';
import '../extension/image_url.dart';
import 'sentiment_dashBoard.dart';

class FearAndGreedData {
  DateTime date;
  String value;
  String classification;

  FearAndGreedData(this.date, this.value, this.classification);
}

// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class FearAndGreedIndexChart extends StatefulWidget {
  String day;
  FearAndGreedIndexChart(this.day, {super.key});

  @override
  _FearAndGreedIndexChartState createState() => _FearAndGreedIndexChartState();
}

// ・0-25 是極度恐懼（Extreme Fear）
// ・26-44 是恐懼（Fear）
// ・45-55 是中立（Neutral）
// ・56-74 是貪婪（Greed）
// ・75-100 是極度貪婪（Extreme Greed）

// ignore: camel_case_types
class sentimentPage extends StatefulWidget {
  const sentimentPage({super.key});

  @override
  State<sentimentPage> createState() => _sentimentPageState();
}

class _FearAndGreedIndexChartState extends State<FearAndGreedIndexChart> {
  List<FearAndGreedData> _dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Fear and Greed Index Chart'),
      // ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: _buildChart(),
      ),
    );
  }

  @override
  void didUpdateWidget(FearAndGreedIndexChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day != widget.day) {
      _getData(widget.day);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData(widget.day);
  }

  Widget _buildChart() {
    if (_dataList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    List<FlSpot> spots = [];
    for (var i = 0; i < _dataList.length; i++) {
      spots.add(FlSpot(i.toDouble(), double.parse(_dataList[i].value)));
    }

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(enabled: false),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: 20.0,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey,
              strokeWidth: 1.0,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: Colors.orange[400],
            barWidth: 2.0,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Future<void> _getData(String selectday) async {
    var url = Uri.parse('https://api.alternative.me/fng/?limit=$selectday');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];
      List<FearAndGreedData> dataList = [];

      for (var item in jsonData) {
        var timestamp = item['timestamp'];
        final parint = int.parse(timestamp);
        var value = item['value'];
        var classification = item['value_classification'];
        var date = DateTime.fromMillisecondsSinceEpoch(parint * 1000);
        dataList.add(FearAndGreedData(date, value, classification));
      }
      debugPrint('${dataList.length}有幾個');
      setState(() {
        _dataList = dataList;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}

// ignore: camel_case_types
class _sentimentPageState extends State<sentimentPage> {
  late SentimentBloc _sentimentBloc;
  late List<selectSentimentDayRange> _selectrange;
  List<selectSentimentDayRange> forchartSelectrange = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Container(
        //   padding: const EdgeInsets.all(30),
        //   color: Colors.blueGrey,
        //   child: const Column(
        //     children: [
        //       CustomText(
        //         textContent: 'Crypto Market \n Fear&Greed',
        //         fontSize: 26,
        //         textColor: Colors.white,
        //       ),
        //     ],
        //   ),
        // ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              BlocBuilder<SentimentBloc, SentimentState>(
                builder: (context, state) {
                  if (state is SentimentLoading) {
                    return const SizedBox(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      child: ShimmerBox(),
                    );
                  } else if (state is SentimentLoaded) {
                    return SizedBox(
                      child: NetworkImageWithPlaceholder(
                        height: screenHeight / 2,
                        width: 200,
                        imageUrl:
                            'https://alternative.me/crypto/fear-and-greed-index.png',
                      ),
                    );
                    // if (state.event is FetchFearData)
                    // if (state.status == SentimentStatus.fearAndGreedIndex) {
                    //   final data = state.feargreedindex[0];
                    //   return fearGreedDashBoard(data);
                    // } else {

                    // }
                  } else {
                    return const Center(
                      child: Text('Failed to fetch news'),
                    );
                  }
                },
              ),
              const Divider(
                color: Colors.blueGrey,
                thickness: 3,
              ),
              Container(
                alignment: Alignment.center,
                height: screenHeight / 12,
                width: screenWidth,
                // color: Colors.amber,
                child: listViewFearAndGreed(),
              ),
              Container(
                alignment: Alignment.center,
                height: screenHeight / 2,
                width: screenWidth,
                color: _selectrange[0].select ? Colors.amber : Colors.blue,
                child: _selectrange[0].select
                    ? FearAndGreedIndexChart('7')
                    : FearAndGreedIndexChart('30'),
              )
            ],
          ),
        ),
      ],
    );
  }

  //dashboard widget
  Widget fearGreedDashBoard(FearGreedIndex data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          alignment: Alignment.topRight,
          margin: const EdgeInsets.only(right: 5),
          // color: Colors.white,
          width: double.infinity,
          height: screenHeight / 16,
          child: CustomText(
            align: TextAlign.right,
            textContent: "NOW:${data.valueClassification}",
            textColor: Colors.black,
            fontSize: 18,
          ),
        ),
        Flex(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: 8,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: screenWidth / 1.3,
                height: screenHeight / 5,
                color: Colors.amber,
                alignment: Alignment.centerLeft,
                child: CarDashboard(value: int.parse(data.value)),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: fetchValueColor(data.value),
                  shape: BoxShape.circle, // 設置形狀為圓形
                ),
                alignment: Alignment.center,
                // color: Colors.amber,
                width: 100,
                height: screenHeight / 9,
                child: CustomText(
                  align: TextAlign.center,
                  textContent: data.value,
                  textColor: Colors.white,
                  fontSize: 18,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  FetchChartData(String day) {
    _sentimentBloc.add(FetchFearData(day, SentimentStatus.fearAndGreedChart));
  }

  Color fetchValueColor(String value) {
    final par = int.parse(value);

    if (par >= 60) {
      return Colors.lightGreen;
    } else if (par <= 40) {
      return Colors.orangeAccent;
    } else {
      return const Color.fromARGB(255, 151, 130, 130);
    }
  }

  @override
  void initState() {
    super.initState();
    _sentimentBloc = context.read<SentimentBloc>();
    _sentimentBloc.add(FetchFearData("7", SentimentStatus.fearAndGreedIndex));
    _selectrange = selectSentimentDayRange.selectSentimentData;
  }

  Widget listViewFearAndGreed() {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(width: 0),
      scrollDirection: Axis.horizontal,
      itemCount: _selectrange.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: screenWidth / 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: InkWell(
                  onTap: () {
                    for (var i = 0; i < _selectrange.length; i++) {
                      if (i == index) {
                        _selectrange[i].select = true;
                      } else {
                        _selectrange[i].select = false;
                      }
                    }
                    // cycleType = CryptoCycleTime.values[index];
                    setState(() {
                      forchartSelectrange = _selectrange;
                      // _selectrange
                      // data = dataResult[CryptoCycleTime.values[index]]!;
                    });
                  },
                  child: _selectrange[index].select
                      ? Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          width: screenWidth / 3,
                          height: screenWidth / 10,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.orange[400], // Light red color
                            borderRadius:
                                BorderRadius.circular(8.0), // Circular border
                          ),
                          child: CustomText(
                            align: TextAlign.center,
                            textContent: "${_selectrange[index].timeTitle}Day",
                            textColor: Colors.white,
                            fontSize: 18,
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          width: screenWidth / 3,
                          height: screenWidth / 10,
                          alignment: Alignment.center,
                          child: CustomText(
                            textContent: "${_selectrange[index].timeTitle}Day",
                            textColor: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                ),
              ))
            ],
          ),
        );
      },
    );
  }
}
