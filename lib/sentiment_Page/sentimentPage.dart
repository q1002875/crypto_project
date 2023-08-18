import 'package:crypto_project/extension/ShimmerText.dart';
import 'package:crypto_project/extension/custom_text.dart';
import 'package:crypto_project/extension/gobal.dart';
import 'package:crypto_project/sentiment_Page/bloc/sentiment_bloc.dart';
import 'package:crypto_project/sentiment_Page/sentiment_api_model_file/sentiment_model.dart';

import '../common.dart';
import 'sentiment_dashBoard.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          color: Colors.blueGrey,
          child: const Column(
            children: [
              CustomText(
                textContent: 'Crypto Market \n Fear&Greed',
                fontSize: 26,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
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
                    return Container();
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
              // BlocBuilder<SentimentBloc, SentimentState>(
              //   builder: (context, state) {
              //     state.event
              //   },
              // ),
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
                  color: fetchValueColor(int.parse(data.value)),
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

  Color fetchValueColor(int value) {
    if (value >= 60) {
      return Colors.lightGreen;
    } else if (value <= 40) {
      return Colors.orangeAccent;
    } else {
      return const Color.fromARGB(255, 151, 130, 130);
    }
  }

  @override
  void initState() {
    super.initState();
    _sentimentBloc = context.read<SentimentBloc>();
    _sentimentBloc.add(FetchFearData("1", SentimentStatus.fearAndGreedIndex));
  }
}
