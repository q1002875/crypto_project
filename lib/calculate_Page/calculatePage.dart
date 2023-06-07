import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_project/extension/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../crypto_Page/crypto_search_page.dart';
import '../crypto_Page/crypto_view_page.dart';
import '../extension/SharedPreferencesHelper.dart';
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
  String _output = "0";
  double _num1 = 0.0;
  double _num2 = 0.0;
  // ignore: prefer_final_fields
  String _output2 = "0";

  late SymbolCase _coin1Id;
  late SymbolCase _coin2Id;
  // String _operator = "";
  Operation _operator = Operation.none;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Flex(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      direction: Axis.vertical,
      children: [
        const SizedBox(
          height: 20,
        ),
        Flexible(
            flex: 4,
            child: GestureDetector(
                onTap: () async {
                  final coinId = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CryptoSearchPage('')),
                  );
                  SharedPreferencesHelper.setString('coinId1', coinId);
                  final result = await fetchMarketData(coinId);

                  debugPrint('${result}here');
                  _coin1Id = result!;

                  //下載即時資料
                  setState(() {});
                },
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                        flex: 2,
                        child: Flex(
                          direction: Axis.vertical,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              flex: 4,
                              child: Container(
                                padding: const EdgeInsets.only(left: 11),
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.blueGrey[700],
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //   shape: BoxShape.circle,
                                  //   border: Border.all(
                                  //     color: Colors.white,
                                  //     width: 0.8,
                                  //   ),
                                  // ),
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: screenWidth / 7,
                                      height: screenWidth / 7,
                                      child: CachedNetworkImage(
                                        width: screenWidth / 7,
                                        height: screenWidth / 7,
                                        placeholder: (context, url) =>
                                            const ShimmerBox(),
                                        imageUrl: _coin1Id.symbolData.image,
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/cryptoIcon.png'),
                                      ),
                                    ),
                                  ),
                                ),
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
                                  child: CustomText(
                                      textContent: _coin1Id.symbolData.coin),
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
                            textContent: _output,
                            textColor: Colors.white,
                            fontSize: 35,
                          ),
                        ))
                  ],
                ))),
        Container(
          color: Colors.grey,
          height: 1,
        ),
        Flexible(
            flex: 4,
            child: GestureDetector(
                onTap: () async {
                  final coinId = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CryptoSearchPage('')),
                  );
                  SharedPreferencesHelper.setString('coinId2', coinId);
                  _coin2Id = (await fetchMarketData(coinId))!;

                  //下載即時資料
                  setState(() {});
                },
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
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //   shape: BoxShape.circle,
                                  //   border: Border.all(
                                  //     color: Colors.white,
                                  //     width: 0.8,
                                  //   ),
                                  // ),
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: screenWidth / 7,
                                      height: screenWidth / 7,
                                      child: CachedNetworkImage(
                                        width: screenWidth / 7,
                                        height: screenWidth / 7,
                                        placeholder: (context, url) =>
                                            const ShimmerBox(),
                                        imageUrl: _coin2Id.symbolData.image,
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/cryptoIcon.png'),
                                      ),
                                    ),
                                  ),
                                ),
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
                                  child: CustomText(
                                      textContent: _coin2Id.symbolData.coin),
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
                            textContent: _output2,
                            textColor: Colors.white,
                            fontSize: 35,
                          ),
                        ))
                  ],
                ))),
        Flexible(
            flex: 14,
            child: Container(
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
            onPressed: () => _buttonPressed(buttonText),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 28.0, color: Colors.white),
            ),
          ),
        ));
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
                debugPrint('上下交換');
                SymbolCase temp = _coin1Id;
                _coin1Id = _coin2Id;
                _coin2Id = temp;
                setState(() {});

                ///更新
              },
              child: const Icon(
                Icons.unfold_less_sharp,
                color: Colors.white,
              ),
            )));
  }

  Future<void> checkSaveCoin() async {
    String coin1 = await SharedPreferencesHelper.getString('coinId1');
    String coin2 = await SharedPreferencesHelper.getString('coinId2');
    if (coin1 == '') {
      coin1 = 'bitcoin';
      final co1 = await fetchMarketData(coin1);
      // debugPrint('${result}here');
      _coin1Id = co1!;
    } else {
      final co1 = await fetchMarketData(coin1);
      // debugPrint('${result}here');
      _coin1Id = co1!;
    }
    if (coin2 == '') {
      coin2 = 'ethereum';
      final co2 = await fetchMarketData(coin2);
      // debugPrint('${result}here');
      _coin2Id = co2!;
    } else {
      final co2 = await fetchMarketData(coin2);
      // debugPrint('${result}here');
      _coin2Id = co2!;
    }

    setState(() {});
  }

  String fetchData(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    print(formattedDate); // Output: 2023-06-05
    return formattedDate;
  }

  Future<SymbolCase?> fetchMarketData(String trick) async {
    String url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$trick&order=market_cap_desc&page=1&sparkline=false&locale=en';
    try {
      // 发送 GET 请求
      var response = await http.get(Uri.parse(url));

      // 检查响应状态码
      if (response.statusCode == 200) {
        // 解析响应数据
        var data = jsonDecode(response.body);
        final id = data[0]['id'];
        final symbol = data[0]['symbol'];
        final name = data[0]['name'];
        final image = data[0]['image'];
        final currentPrice = data[0]['current_price'];
        final changePirce = data[0]['price_change_24h']; //變化的美元
        final changePercent = data[0]["last_updated"]; //變化的百分比
        final trick = Trickcrypto(symbol, id, name, image);

        return SymbolCase(trick, currentPrice, changePercent, changePirce);
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      debugPrint('Error occurred: $error');
      return null;
    }
    return null;
  }

  @override
  initState() {
    super.initState();
    // // TODO: implement initState
    // super.initState();

    // _coin1Id = SymbolCase(
    //     Trickcrypto("btc", "btc", "Bitcoin",
    //         "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"),
    //     0,
    //     "2021-11-06T21:54:35.825Z",
    //     0);

    // _coin2Id = SymbolCase(
    //     Trickcrypto("eth", "ethereum", "Ethereum",
    //         "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880"),
    //     0,
    //     "2021-11-06T21:54:35.825Z",
    //     0);

    // final result = await fetchMarketData('bitcoin');
    // debugPrint('${result}here');
    // _coin1Id = result!;

    // final result2 = await fetchMarketData('ethereum');
    // debugPrint('${result}here');
    // _coin2Id = result2!;
    // setState(() {});

    // setState(() {});

    try {
      checkSaveCoin();
    } catch (error) {}
  }

  void _buttonPressed(String buttonText) {
    switch (buttonText) {
      case "⌫":
        _output = _output = _output.substring(0, _output.length - 1);
        _num1 = 0.0;
        _num2 = 0.0;
        _operator = Operation.none;
        break;

      case "C":
        _output = "0";
        _num1 = 0.0;
        _num2 = 0.0;
        _operator = Operation.none;
        break;
      case "+":
        _num1 = double.parse(_output);
        _operator = Operation.add;
        _output = "0";
        break;
      case "-":
        _num1 = double.parse(_output);
        _operator = Operation.subtract;
        _output = "0";
        break;
      case "×":
        _num1 = double.parse(_output);
        _operator = Operation.multiply;
        _output = "0";
        break;
      case "÷":
        _num1 = double.parse(_output);
        _operator = Operation.divide;
        _output = "0";
        break;
      case ".":
        if (_output.contains(".")) return;
        _output += buttonText;
        break;
      case "=":
        _num2 = double.parse(_output);
        double result;
        switch (_operator) {
          case Operation.add:
            result = _num1 + _num2;
            break;
          case Operation.subtract:
            result = _num1 - _num2;
            break;
          case Operation.multiply:
            result = _num1 * _num2;
            break;
          case Operation.divide:
            result = _num1 / _num2;
            break;
          default:
            result = 0.0;
            break;
        }
        _output = (result == result.toInt())
            ? result.toInt().toString()
            : result.toString();
        _num1 = 0.0;
        _num2 = 0.0;
        _operator = Operation.none;
        break;

      default:
        if (_output.characters.length == 1 && _output == '0') {
          _output = '';
        }
        _output += buttonText;
        break;
    }

    setState(() {
      _output2 = (double.parse(_output) * (_coin1Id.price / _coin2Id.price))
          .toStringAsFixed(4);

      if (_output == '0') {
        _output2 = '0';
      }
    });
  }
}
