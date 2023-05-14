import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../account_Page/login/bloc/login_bloc.dart';
import '../account_Page/login/login_provider.dart';
import 'bloc/crypto_response.dart';

class BinanceWebSocket extends StatefulWidget {
  const BinanceWebSocket({super.key});

  @override
  _BinanceWebSocketState createState() => _BinanceWebSocketState();
}

class _BinanceWebSocketState extends State<BinanceWebSocket> {
  final channel =
      IOWebSocketChannel.connect('wss://stream.binance.com:9443/ws');
  var showprice = '';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('123132'),
        ),
        body: Center(child: Text('${userProvider.isLoggedIn}')));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    channel.stream.listen((message) {
      // 在此處理收到的訊息
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
          showprice = '$symbol:$price';
          print('$symbol:$price');
          break;
      }
      setState(() {});
    });

    // 訂閱不同貨幣對應的資料流
    // subscribeToTickerStream('btcusdt@ticker');
    // subscribeToTickerStream('ethusdt@ticker');
    // subscribeToTickerStream('bnbusdt@ticker');
    subscribeToTickerStream('aptusdt@ticker');
  }

  void subscribeToTickerStream(String symbol) {
    final tickerStreamPayload =
        '{"method":"SUBSCRIBE","params":["$symbol"],"id":1}';
    channel.sink.add(tickerStreamPayload);
  }

  Widget _buildContent(BuildContext context, AuthenticationState state) {
    switch (state.runtimeType) {
      case AuthenticationLoading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case AuthenticatedisMember:
        final isMember = (state as AuthenticatedisMember).isMember;
        final user = (state).user;
        if (isMember) {
          return const Text('is member');
        } else {
          return const Text('not member');
        }

      case UnauthenticatedState:
        return const Text('失敗');
      default:
        return ElevatedButton(
          onPressed: () {},
          child: const Text('不是會員按google登入'),
        );
    }
  }
}
