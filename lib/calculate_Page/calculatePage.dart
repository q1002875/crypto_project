import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_project/calculate_Page/bloc/calculate_bloc_bloc.dart';
import 'package:crypto_project/extension/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../crypto_Page/crypto_view_page.dart';
import '../extension/ShimmerText.dart';
import '../extension/gobal.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorPageState createState() => _CalculatorPageState();
}

enum Operation { add, subtract, multiply, divide, none }

class _CalculatorPageState extends State<CalculatorPage> {
  late SymbolCase _coin1Id;
  late SymbolCase _coin2Id;
  late CalculateBlocBloc _calculateBloc;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.blueGrey, // Transparent status bar
      statusBarIconBrightness: Brightness.dark, // Dark mode for status bar
    ));
    return Scaffold(
        // appBar: AppBar(backgroundColor: Colors.blueGrey),
        body: BlocBuilder<CalculateBlocBloc, CalculateBlocState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case CalculateBlocLoading:
            return loadingMainView();
          case CalculateBlocLoaded:
            final data = (state as CalculateBlocLoaded);
            _coin1Id = data.symbolcase[0];
            _coin2Id = data.symbolcase[1];
            return mainView('0', '0');
          case CalculatePressed:
            final data = (state as CalculatePressed);
            return mainView(data.outputCase[0], data.outputCase[1]);
          case CalculateUpDownLoaded:
            final data = (state as CalculateUpDownLoaded);
            _coin1Id = data.symbolcase[0];
            _coin2Id = data.symbolcase[1];
            return mainView(data.outputList[0], data.outputList[1]);
          case CalculateBlocError:
            return loadingMainView();
        }
        return Container();
      },
    ));
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.1),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
          color: buttonColor,
          child: TextButton(
            onPressed: () => _calculateBloc.add(PressButton(buttonText)),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 28.0, color: Colors.white),
            ),
          ),
        ));
  }

  TableRow buildButtonRow(List<String> buttonRow, Color color) {
    return TableRow(
      children: buttonRow.map((buttonLabel) {
        return buildButton(buttonLabel, 1, color);
      }).toList(),
    );
  }

  Widget buildIconButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.1),
        ),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
            color: buttonColor,
            child: GestureDetector(
              onTap: () {
                _calculateBloc.add(UpdownCoin());
              },
              child: const Icon(
                Icons.unfold_less_sharp,
                color: Colors.white,
              ),
            )));
  }

  Widget buttonTable(double width, List<List<String>> buttonRows, Color color) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * width,
      child: Table(
        children: buttonRows.map((buttonRow) {
          return buildButtonRow(buttonRow, color);
        }).toList(),
      ),
    );
  }

  Widget calculateView() {
    return Container(
      // color: Colors.pink,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .75,
            child: Table(
              children: [
                TableRow(children: [
                  buildButton("C", 1, Colors.black54),
                  buildButton("⌫", 1, Colors.black54),
                  buildIconButton("÷", 1, Colors.black54),
                ]),
                TableRow(children: [
                  buildButton("7", 1, Colors.grey),
                  buildButton("8", 1, Colors.grey),
                  buildButton("9", 1, Colors.grey),
                ]),
                TableRow(children: [
                  buildButton("4", 1, Colors.grey),
                  buildButton("5", 1, Colors.grey),
                  buildButton("6", 1, Colors.grey),
                ]),
                TableRow(children: [
                  buildButton("1", 1, Colors.grey),
                  buildButton("2", 1, Colors.grey),
                  buildButton("3", 1, Colors.grey),
                ]),
                TableRow(children: [
                  buildButton(".", 1, Colors.grey),
                  buildButton("0", 1, Colors.grey),
                  buildButton("00", 1, Colors.grey),
                ]),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .25,
            child: Table(
              children: [
                TableRow(children: [
                  buildButton("÷", 1, Colors.orange),
                ]),
                TableRow(children: [
                  buildButton("×", 1, Colors.orange),
                ]),
                TableRow(children: [
                  buildButton("-", 1, Colors.orange),
                ]),
                TableRow(children: [
                  buildButton("+", 1, Colors.orange),
                ]),
                TableRow(children: [
                  buildButton("=", 1, Colors.orange),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget coinSection(
      bool item, SymbolCase coin, String output, VoidCallback onTap) {
    return Flexible(
        flex: 4,
        child: GestureDetector(
            onTap: onTap,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                    flex: 2,
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Container(
                            padding: const EdgeInsets.only(left: 11),
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.blueGrey[700],
                            alignment: Alignment.centerLeft,
                            child: cryptoImage(coin.symbolData.image),
                          ),
                        ),
                        Flexible(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.only(left: 5),
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.blueGrey[700],
                              alignment: Alignment.topCenter,
                              child:
                                  CustomText(textContent: coin.symbolData.coin),
                            ))
                      ],
                    )),
                Flexible(
                    flex: 8,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.blueGrey[700],
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        textContent: output,
                        textColor: Colors.white,
                        fontSize: 24,
                      ),
                    ))
              ],
            )));
  }

  Widget cryptoImage(String imageUrl) {
    return ClipOval(
      child: SizedBox(
        width: screenWidth / 7,
        height: screenWidth / 7,
        child: CachedNetworkImage(
          width: screenWidth / 7,
          height: screenWidth / 7,
          placeholder: (context, url) => const ShimmerBox(),
          imageUrl: imageUrl,
          errorWidget: (context, url, error) =>
              Image.asset('assets/cryptoIcon.png'),
        ),
      ),
    );
  }

  String fetchData(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}/fdcdd${date.hour}:${date.minute}";
    // print(formattedDate); // Output: 2023-06-05
    return formattedDate;
  }

  @override
  initState() {
    super.initState();
    _calculateBloc = BlocProvider.of<CalculateBlocBloc>(context);
    _calculateBloc.add(FetchInitData());
  }

  Widget loadingMainView() {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      direction: Axis.vertical,
      children: [
        Flexible(
          flex: 10,
          child: Shimmer.fromColors(
            baseColor: Colors.blueGrey, // 更改此颜色为你想要的颜色
            highlightColor: Colors.grey, // 更改此颜色为你想要的颜色
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            ),
          ),
        ),
        Flexible(flex: 14, child: calculateView()),
        Flexible(
          flex: 2,
          child: Shimmer.fromColors(
            baseColor: Colors.blueGrey, // 更改此颜色为你想要的颜色
            highlightColor: Colors.grey, // 更改此颜色为你想要的颜色
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget mainView(String output1, String output2) {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      direction: Axis.vertical,
      children: [
        const SizedBox(
          height: 20,
        ),
        coinSection(true, _coin1Id, output1, () {
          _calculateBloc.add(PressChangeCoin(context, '0'));
        }),
        Container(
          color: Colors.grey,
          height: 1,
        ),
        coinSection(false, _coin2Id, output2, () {
          _calculateBloc.add(PressChangeCoin(context, '1'));
        }),
        Flexible(
            flex: 14,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(flex: 14, child: calculateView()),
                ],
              ),
            )),
        Flexible(
            flex: 2,
            child: Container(
              color: Colors.grey[700],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //按下匯率更新
                      _calculateBloc.add(FetchInitData());
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    child: const Icon(
                      Icons.replay_sharp,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    // color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          textContent: fetchData(_coin1Id.changePercent),
                          align: TextAlign.center,
                          textColor: Colors.greenAccent,
                          fontSize: 12,
                        ),
                        CustomText(
                          textContent:
                              '1 ${_coin1Id.symbolData.coin.toUpperCase()} = ${(_coin1Id.price / _coin2Id.price).toStringAsFixed(4)} ${_coin2Id.symbolData.coin.toUpperCase()}',
                          textColor: const Color.fromARGB(255, 198, 191, 191),
                          fontSize: 12,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ],
    );
  }
}
