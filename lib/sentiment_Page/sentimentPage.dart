import 'package:crypto_project/extension/ShimmerText.dart';
import 'package:crypto_project/extension/custom_text.dart';
import 'package:crypto_project/extension/gobal.dart';
import 'package:crypto_project/sentiment_Page/FearAndGreedHistryValue.dart';
import 'package:crypto_project/sentiment_Page/FearAndGreedIndexChart.dart';
import 'package:crypto_project/sentiment_Page/bloc/sentiment_bloc.dart';
import 'package:crypto_project/sentiment_Page/sentiment_api_model_file/sentiment_api.dart';
import 'package:crypto_project/sentiment_Page/sentiment_api_model_file/sentiment_model.dart';

import '../common.dart';
import '../extension/image_url.dart';

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

// ignore: camel_case_types
class _sentimentPageState extends State<sentimentPage> {
  late SentimentBloc _sentimentBloc;
  late List<selectSentimentDayRange> _selectrange;
  List<selectSentimentDayRange> forchartSelectrange = [];
  List<FearAndGreedData> fourDayData = [];
  List<FearAndGreedData> sevenDayData = [];
  List<FearAndGreedData> thrtyDayData = [];

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
                        width: screenWidth,
                        boxfit: BoxFit.contain,
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
                thickness: 6,
              ),
              Container(
                alignment: Alignment.center,
                height: screenHeight / 12,
                width: screenWidth,
                // color: Colors.amber,
                child: listViewFearAndGreed(),
              ),
              Container(
                // alignment: Alignment.center,
                height: screenHeight / 2,
                width: screenWidth,
                color: _selectrange[0].select ? Colors.amber : Colors.blue,
                child: _selectrange[0].select
                    ? FearAndGreedIndexChart(sevenDayData)
                    : FearAndGreedIndexChart(thrtyDayData),
              ),
              const Divider(
                color: Colors.blueGrey,
                thickness: 6,
              ),
              Container(
                  alignment: Alignment.center,
                  height: screenHeight / 2,
                  width: screenWidth,
                  // color: _selectrange[0].select ? Colors.amber : Colors.blue,
                  child: FearAndGreedHistoryValue(fourDayData))
            ],
          ),
        ),
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

  Future<void> getsentimentData() async {
    fourDayData = await SentimentApi.getSentimentData("4");
    sevenDayData = await SentimentApi.getSentimentData("7");
    thrtyDayData = await SentimentApi.getSentimentData("30");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _sentimentBloc = context.read<SentimentBloc>();
    _sentimentBloc.add(FetchFearData("7", SentimentStatus.fearAndGreedIndex));
    _selectrange = selectSentimentDayRange.selectSentimentData;
    getsentimentData();
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
                        _selectrange[i].select = (i == index);
                      }
                      setState(() {
                        forchartSelectrange = _selectrange;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      width: screenWidth / 3,
                      height: screenWidth / 10,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _selectrange[index].select
                            ? Colors.orange[400]
                            : null,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: CustomText(
                        align: TextAlign.center,
                        textContent: "${_selectrange[index].timeTitle} Day",
                        textColor: _selectrange[index].select
                            ? Colors.white
                            : Colors.grey,
                        fontSize: 18,
                      ),
                    )),
              ))
            ],
          ),
        );
      },
    );
  }
}
