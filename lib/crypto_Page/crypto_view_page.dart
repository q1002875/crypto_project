import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../database_mongodb/maongo_database.dart';
import '../extension/SharedPreferencesHelper.dart';
import '../extension/crypto_font.dart';
import '../routes.dart';

class BinanceWebSocket extends StatefulWidget {
  const BinanceWebSocket({Key? key}) : super(key: key);

  @override
  _BinanceWebSocketState createState() => _BinanceWebSocketState();
}

class _BinanceWebSocketState extends State<BinanceWebSocket> {
  MongoDBConnection mongodb = MongoDBConnection();
  var showprice = '';
  var searchCrypto = '';
  List<SymbolCase> tickData = [];
  String userid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto'),
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
      body:
       ListView.builder(
        itemCount: tickData.length,
        itemBuilder: (context, index) {
          final message = '${tickData[index].symbol}:${tickData[index].price}';
          final font = CryptoFont.getIcon(tickData[index].symbol);
          IconData iconData = font;
          // const d = CryptoFontIcons.ADC;
          return IconButton(
      // Bitcoin
      icon:  Icon(font), onPressed: () {  },
     );
          //  ListTile(
          //   title: Text(message),
          // );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getSharedDataStream() async {
    userid = await SharedPreferencesHelper.getString('userId');
    await mongodb.connect();
    final cryptoData =
        await mongodb.getUserCryptoData(userid, ConnectDbName.crypto);
    if (cryptoData != null) {
      String cryptoString = cryptoData.crypto.map((element) {
        final coin = element.toUpperCase().replaceAll('USDT', '');
        return coin;
      }).join(',');
      searchCrypto = cryptoString;
     repeatPrice();
    } else {
      debugPrint('cryptoData is null');
    }
  }

  @override
  void initState() {
    super.initState();
   getSharedDataStream();
  }

  void repeatPrice() {
    Timer.periodic(const Duration(seconds: 60), (Timer timer) {
      tickData.clear();
      fetchMarketData(searchCrypto);
    });
  }

  Future<void> fetchMarketData(String p) async {
    String apiKey = '6e35c3bf-1346-4a87-9bae-25fe6ea51136';
    String url =
        'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest';
    Map<String, String> headers = {
      'X-CMC_PRO_API_KEY': apiKey,
    };
    Map<String, String> parameters = {
      'symbol': p, // 要获取行情的加密货币符号，用逗号分隔
      // 'convert': 'USD', // 要将行情转换为的货币单位
    };
    try {
      // 发送 GET 请求
      var response = await http.get(
          Uri.parse(url).replace(queryParameters: parameters),
          headers: headers);

      // 检查响应状态码
      if (response.statusCode == 200) {
        // 解析响应数据
        var data = jsonDecode(response.body);
        debugPrint('json得資料在這$data');
        // 提取加密货币行情数据
        Map<String, dynamic> quotes = data['data'];

        quotes.forEach((symbol, quoteData) {
          String name = quoteData['symbol'];
          double price = quoteData['quote']['USD']['price'];
          String formattedPrice = price.toStringAsFixed(3);
          tickData.add(SymbolCase(name, formattedPrice));
        });
        setState(() {});
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  Future<Image> fetchSymbolImage(String symbol) async {
    final url = 'https://api.coinbase.com/v2/assets/icons/$symbol.png';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final imageData = response.bodyBytes;
      final image = Image.memory(imageData);
      return image;
    } else {
      throw Exception('Failed to load symbol image');
    }
  }

}

class SymbolCase {
  String symbol;
  String price;
  SymbolCase(this.symbol, this.price);
}
