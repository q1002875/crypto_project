

import 'package:flutter/material.dart';

import '../extension/SharedPreferencesHelper.dart';
import '../routes.dart';

class BinanceWebSocket extends StatefulWidget {

 const BinanceWebSocket({super.key});

  @override
  _BinanceWebSocketState createState() => _BinanceWebSocketState();
}

class _BinanceWebSocketState extends State<BinanceWebSocket> {
  // final channel =
  //     IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws');
  var showprice = '';

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('123132'),
      ),
      body: FutureBuilder<String>(
        future: getSharedData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 如果异步操作还在进行中，可以显示加载指示器或其他等待状态的小部件
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 如果异步操作出错，可以显示错误信息
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data;
            return Center(
              child: data != null && data.isNotEmpty
                  ? Text(data + showprice)
                  : ElevatedButton(
          onPressed: () {
           Navigator.pushNamed(context, Routes.account);
          },
          child: const Text('前往登入'),
        )
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    // channel.sink.close();
    super.dispose();
  }

 Future<String>getSharedData() async{
return await SharedPreferencesHelper.getString('userId') ;  
 }

  @override
  void initState() {
    super.initState();
     
     
    // channel.stream.listen((message) {
    //   // 在此處理收到的訊息
    //   Map<String, dynamic> getJson = jsonDecode(message);
    //   final data = TickerData.fromJson(getJson);
    //   final symbol = data.symbol;
    //   final price = data.prevClosePrice;
    //   switch (symbol) {
    //     case 'BTCUSDT':
    //       print('$symbol:${data.prevClosePrice}');
    //       break;
    //     case 'ETHUSDT':
    //       print('$symbol:$price');
    //       break;
    //     case 'BNBUSDT':
    //       print('$symbol:$price');
    //       break;
    //     case 'APTUSDT':
    //       showprice = '$symbol:$price';
    //       print('$symbol:$price');
    //       break;
    //   }
    //   setState(() {});
    // });

    // // 訂閱不同貨幣對應的資料流
    // // subscribeToTickerStream('btcusdt@ticker');
    // // subscribeToTickerStream('ethusdt@ticker');
    // // subscribeToTickerStream('bnbusdt@ticker');
    // subscribeToTickerStream('aptusdt@ticker');
  }

  // void subscribeToTickerStream(String symbol) {
  //   final tickerStreamPayload =
  //       '{"method":"SUBSCRIBE","params":["$symbol"],"id":1}';
  //   channel.sink.add(tickerStreamPayload);
  // }

  // Widget _buildContent(BuildContext context, AuthenticationState state) {
  //   switch (state.runtimeType) {
  //     case AuthenticationLoading:
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     case AuthenticatedisMember:
  //       final isMember = (state as AuthenticatedisMember).isMember;
  //       final user = (state).user;
  //       if (isMember) {
  //         return const Text('is member');
  //       } else {
  //         return const Text('not member');
  //       }

  //     case UnauthenticatedState:
  //       return const Text('失敗');
  //     default:
  //       return ElevatedButton(
  //         onPressed: () {},
  //         child: const Text('不是會員按google登入'),
  //       );
  //   }
  // }
}
