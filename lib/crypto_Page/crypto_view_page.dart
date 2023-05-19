

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../database_mongodb/maongo_database.dart';
import '../extension/SharedPreferencesHelper.dart';
import '../routes.dart';
import 'bloc/crypto_response.dart';
class BinanceWebSocket extends StatefulWidget {
  const BinanceWebSocket({Key? key}) : super(key: key);

  @override
  _BinanceWebSocketState createState() => _BinanceWebSocketState();
}

class _BinanceWebSocketState extends State<BinanceWebSocket> {
   MongoDBConnection mongodb = MongoDBConnection();
  final channel =
      IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws');
  var showprice = '';
  List<SymbolCase> tickData = [];
  StreamSubscription? _streamSubscription;
  String userid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title:const Text('Crypto'),
  actions: <Widget>[
    userid != ''?  IconButton(
      icon:const Icon(Icons.search),
      onPressed: () {
          Navigator.pushNamed(context, Routes.cryptoSearch,
                        arguments: userid);
      },
    )
    :Container()
  ],
),
      body:
      
       ListView.builder(
        itemCount: tickData.length,
        itemBuilder: (context, index) {
          final message = '${tickData[index].symbol}:${tickData[index].price}' ;
          return ListTile(
            title: Text(message),
          );
        },
      ),
      
      
      //  Container(child: Text(showprice))
      
      
      //  StreamBuilder<String>(
      //   stream: getSharedDataStream(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     } else {
      //       final data = snapshot.data;
      //       return Center(
      //         child: data != null && data.isNotEmpty
      //             ?  Text(showprice)
      //             // Container(child: ListView.builder(
      //             //       scrollDirection: Axis.vertical,
      //             //       itemCount: tickData.length,
      //             //       itemBuilder: (context, index) {
      //             //         final data = tickData[index].prevClosePrice;
      //             //         return GestureDetector(
      //             //             onTap: () {
      //             //               // Navigator.pushNamed(context, Routes.newsDetail,
      //             //               //     arguments: news);
      //             //             },
      //             //             child: );
      //             //       },
      //             //     )
      //             // )
      //             : ElevatedButton(
      //                 onPressed: () {
      //                   Navigator.pushNamed(context, Routes.account);
      //                 },
      //                 child: const Text('前往登入'),
      //               ),
      //       );
      //     }
      //   },
      // ),
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    channel.sink.close();
    super.dispose();
  }

  Future<void> getSharedDataStream() async {
     userid = await SharedPreferencesHelper.getString('userId');
    await mongodb.connect();
    final cryptoData =
        await mongodb.getUserCryptoData(userid, ConnectDbName.crypto);
if (cryptoData != null){
      for (var element in cryptoData.crypto) {
        final coin = element.toLowerCase();
        subscribeToTickerStream('$coin@ticker');
      }
}else{
  debugPrint('cryptoData is null');
}

  }

  @override
  void initState() {
    super.initState();
    getSharedDataStream();
// subTest();
    listenMessage();
  }

  void subTest(){
     subscribeToTickerStream('btcusdt@ticker');
      subscribeToTickerStream('ethusdt@ticker');
  }

  void listenMessage() {
  _streamSubscription = channel.stream.listen((message) {
    Map<String, dynamic> getJson = jsonDecode(message);
      debugPrint('$getJson這裡getJson');
    final data = TickerData.fromJson(getJson);
    final symbol = data.symbol;
    final price = data.prevClosePrice;
    final messageToShow = '$symbol: $price';
    debugPrint('$messageToShow這裡message');
    int existingIndex =  tickData.indexWhere((item) => item.symbol == symbol);
    if (existingIndex != -1) {
      setState(() {
         tickData[existingIndex] = SymbolCase(symbol, price); // 更新現有資料
      });
    } else {
      setState(() {
         tickData.add(SymbolCase(symbol, price)); // 新增新資料
      });
    }
  });
}

  void subscribeToTickerStream(String symbol) {
    final tickerStreamPayload =
        '{"method":"SUBSCRIBE","params":["$symbol"],"id":1}';
    channel.sink.add(tickerStreamPayload);
  }
}


class SymbolCase{
String symbol;
String price;
SymbolCase(this.symbol,this.price);
}