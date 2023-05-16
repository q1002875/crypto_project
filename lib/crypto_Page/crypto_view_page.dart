

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

import '../extension/SharedPreferencesHelper.dart';
import '../routes.dart';
import 'bloc/crypto_response.dart';
class BinanceWebSocket extends StatefulWidget {
  const BinanceWebSocket({Key? key}) : super(key: key);

  @override
  _BinanceWebSocketState createState() => _BinanceWebSocketState();
}

class _BinanceWebSocketState extends State<BinanceWebSocket> {
  final channel =
      IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws');
  var showprice = '';
  List<TickerData> tickData = [];
  StreamSubscription? _streamSubscription;
  String userid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(userid),
  actions: <Widget>[
    userid == ''?  IconButton(
      icon:const Icon(Icons.search),
      onPressed: () {
          Navigator.pushNamed(context, Routes.cryptoSearch,
                        arguments: userid);
      },
    )
    
    :Container()
   
  ],
),
      body: StreamBuilder<String>(
        stream: getSharedDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data;
            return Center(
              child: data != null && data.isNotEmpty
                  ? Text(showprice)
                  
                  // Container(child: ListView.builder(
                  //       scrollDirection: Axis.vertical,
                  //       itemCount: tickData.length,
                  //       itemBuilder: (context, index) {
                  //         final data = tickData[index].prevClosePrice;
                  //         return GestureDetector(
                  //             onTap: () {
                  //               // Navigator.pushNamed(context, Routes.newsDetail,
                  //               //     arguments: news);
                  //             },
                  //             child: );
                  //       },
                  //     )
                  // )
                  
                  
                  
                  
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.account);
                      },
                      child: const Text('前往登入'),
                    ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    channel.sink.close();
    super.dispose();
  }

  Stream<String> getSharedDataStream() async* {
    yield userid = await SharedPreferencesHelper.getString('userId');
  }

  @override
  void initState() {
    super.initState();

    _streamSubscription = channel.stream.listen((message) {
      Map<String, dynamic> getJson = jsonDecode(message);
      final data = TickerData.fromJson(getJson);
      final symbol = data.symbol;
      final price = data.prevClosePrice;
      switch (symbol) {
        case 'BTCUSDT':
          print('$symbol:${data.prevClosePrice}');
          break;
        case 'ETHUSDT':
          print('$symbol:$price');
          break;
        case 'BNBUSDT':
          print('$symbol:$price');
          break;
        case 'APTUSDT':
          setState(() {
            showprice = '$symbol:$price';
          });
          print('$symbol:$price');
          break;
      }
    });

    // subscribeToTickerStream('btcusdt@ticker');
    // subscribeToTickerStream('ethusdt@ticker');
    // subscribeToTickerStream('bnbusdt@ticker');
    // subscribeToTickerStream('aptusdt@ticker');
  }

  void subscribeToTickerStream(String symbol) {
    final tickerStreamPayload =
        '{"method":"SUBSCRIBE","params":["$symbol"],"id":1}';
    channel.sink.add(tickerStreamPayload);
  }
}
