import 'package:crypto_project/extension/ShimmerText.dart';
import 'package:crypto_project/extension/custom_text.dart';
import 'package:crypto_project/extension/gobal.dart';
import 'package:crypto_project/sentiment_Page/FearAndGreedIndexChart.dart';
import 'package:crypto_project/sentiment_Page/sentiment_api_model_file/sentiment_model.dart';

import '../common.dart';

// ignore: must_be_immutable
// ignore: must_be_immutable
class FearAndGreedHistoryValue extends StatelessWidget {
  List<FearAndGreedData> data;

  FearAndGreedHistoryValue(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:
                (data.isNotEmpty) ? setHistoryCell() : [const ShimmerBox()]));
  }

  Widget historyCellTitle() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        width: screenWidth,
        child: const CustomText(
          textContent: 'Historical Values',
          textColor: Color.fromARGB(255, 244, 173, 8),
          align: TextAlign.left,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget historyCellVieww(
      String time, String sentimentTitle, Color color, String value) {
    return Expanded(
      flex: 1,
      child: Container(
        width: screenWidth,
        // color: Colors.pink,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              // alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      // color: Colors.green,
                      child: CustomText(
                        align: TextAlign.center,
                        textContent: time,
                        textColor: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      // color: Colors.amber,
                      child: CustomText(
                        align: TextAlign.center,
                        textContent: sentimentTitle,
                        textColor: color,
                        fontSize: 18,
                      ),
                    )
                  ]),
            ),
            Container(
              padding: const EdgeInsets.only(right: 30),
              child: ClipOval(
                child: Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  color: color,
                  child: CustomText(
                    textContent: value,
                    textColor: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> setHistoryCell() {
    List<String> daytitle = ['Now', 'Yesterday', 'Last Week', 'Last Month'];
    List<Widget> data = [];
    data.add(historyCellTitle());

    for (int i = 0; i < this.data.length; i++) {
      final element = this.data[i];

      // final day = widget.data[i].date.toString();
      final value = element.value;
      final title = element.classification;
      final getSentimentLevelModel = getSentimentLevel(int.parse(value));
      // final level = getSentimentLevelModel['level'];
      final color = getSentimentLevelModel['color'];
      data.add(historyCellVieww(daytitle[i], title, color, value));
    }
    return data;
  }
}
