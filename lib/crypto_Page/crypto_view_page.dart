import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_project/crypto_Page/crypto_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../database_mongodb/maongo_database.dart';
import '../extension/SharedPreferencesHelper.dart';
import '../extension/ShimmerText.dart';
import '../extension/custom_text.dart';
import '../main.dart';
import '../routes.dart';
import 'crypto_detail_chart.dart';

class BinanceWebSocket extends StatefulWidget {
  const BinanceWebSocket({Key? key}) : super(key: key);

  @override
  _BinanceWebSocketState createState() => _BinanceWebSocketState();
}

class SymbolCase {
  Trickcrypto symbolData;
  dynamic price;
  dynamic changePrice;
  dynamic changePercent;

  SymbolCase(this.symbolData, this.price, this.changePercent, this.changePrice);
}

class _BinanceWebSocketState extends State<BinanceWebSocket> {
  var showprice = '';
  var searchCrypto = '';
  List<SymbolCase> tickData = [];
  String userid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Crypto List'),
        actions: <Widget>[
          userid != ''
              ? IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.cryptoSearch,
                        arguments: userid);
                  },
                )
              : Container()
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData, // 在这里指定你的数据刷新方法
        child: tickData.isNotEmpty
            ? ListView.builder(
                itemCount: tickData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, Routes.cryptochart());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LineChartPage(tickData[index].symbolData)),
                        );
                      },
                      child: listviewCell(tickData[index]));
                },
              )
            : const SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: ShimmerBox(),
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchMarketData(String p) async {
    String url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$p&order=market_cap_desc&page=1&sparkline=false&locale=en';
    try {
      // 发送 GET 请求
      var response = await http.get(Uri.parse(url));

      // 检查响应状态码
      if (response.statusCode == 200) {
        // 解析响应数据
        var data = jsonDecode(response.body);
        // debugPrint('json得資料在這$data');
        // 提取加密货币行情数据
        // Map<String, dynamic> quotes = data;

        data.forEach(
          (element) {
            final id = element['id'];
            final symbol = element['symbol'];
            final name = element['name'];
            final image = element['image'];
            final currentPrice = element['current_price'];
            final changePirce = element['price_change_24h']; //變化的美元
            final changePercent =
                element['price_change_percentage_24h']; //變化的百分比
            final trick = Trickcrypto(symbol, id, name, image);

            tickData.add(
                SymbolCase(trick, currentPrice, changePercent, changePirce));
          },
        );

        setState(() {});
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error occurred: $error');
    }
  }

  Future<Trickcrypto?> fetchSearchCoin(String symbol) async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/coindata.json');
      List<dynamic> coins = json.decode(jsonString);
      Map<String, dynamic> coinMap = {for (var coin in coins) coin['id']: coin};

      String name = coinMap[symbol]['name'];
      String symbolName = coinMap[symbol]['symbol'];
      String id = coinMap[symbol]['id'];
      String image = coinMap[symbol]['image'];
      return Trickcrypto(symbolName, id, name, image);
    } catch (error) {
      return null;
    }
  }

  Future<void> getSharedDataStream() async {
    userid = await SharedPreferencesHelper.getString('userId');
    final cryptoData =
        await mongodb.getUserCryptoData(userid, ConnectDbName.crypto);
    if (cryptoData != null) {
      String cryptoString = cryptoData.crypto.map((element) {
        fetchSearchCoin(element);
        final coin = element.toLowerCase();
        return coin;
      }).join(',');
      searchCrypto = cryptoString;
      tickData.clear();
      fetchMarketData(cryptoString);
      //看要多久去拿數據
      // repeatPrice();
    } else {
      debugPrint('cryptoData is null');
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedDataStream();
    // repeatPrice();
  }

  Widget listviewCell(SymbolCase data) {
    final image = data.symbolData.image;
    final symbol = data.symbolData.coin;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(8),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const ShimmerBox(),
                  imageUrl: image,
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/cryptoIcon.png'),
                ),
              )),
          const SizedBox(width: 5),
          Flexible(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  align: TextAlign.start,
                  textContent: '${symbol.toUpperCase()}USDT',
                  textColor: Colors.black,
                  fontSize: 14,
                ),
              )),
          const SizedBox(width: 5),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  CustomText(
                    align: TextAlign.right,
                    textContent: data.price.toStringAsFixed(4).toString(),
                    textColor: Colors.black,
                    fontSize: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomText(
                        align: TextAlign.right,
                        textContent: data.changePrice > 0
                            ? '+${data.changePrice.toStringAsFixed(3)}'
                            : data.changePrice.toStringAsFixed(3).toString(),
                        textColor:
                            data.changePrice > 0 ? Colors.green : Colors.red,
                        fontSize: 14,
                      ),
                      CustomText(
                        align: TextAlign.right,
                        textContent: data.changePercent > 0
                            ? '+${data.changePercent.toStringAsFixed(2)}%'
                            : '${data.changePercent.toStringAsFixed(2)}%',
                        textColor:
                            data.changePercent > 0 ? Colors.green : Colors.red,
                        fontSize: 14,
                      ),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }

  void repeatPrice() {
    Timer.periodic(const Duration(seconds: 15), (Timer timer) {
      tickData.clear();
      fetchMarketData(searchCrypto);
    });
  }

  Future<void> _refreshData() async {
    getSharedDataStream();
    setState(() {});
  }
}
