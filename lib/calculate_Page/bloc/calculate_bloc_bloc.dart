import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto_project/crypto_Page/crypto_view_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../crypto_Page/crypto_search_page.dart';
import '../../extension/SharedPreferencesHelper.dart';
import '../calculatePage.dart';

part 'calculate_bloc_event.dart';
part 'calculate_bloc_state.dart';

class CalculateBlocBloc extends Bloc<CalculateBlocEvent, CalculateBlocState> {
  String _output = "0";
  double _num1 = 0.0;
  double _num2 = 0.0;
  String _output2 = "0";

  late SymbolCase _coin1Id;
  late SymbolCase _coin2Id;
  Operation _operator = Operation.none;
  CalculateBlocBloc() : super(CalculateBlocInitial()) {
    on<CalculateBlocEvent>((event, emit) async {
      if (event is FetchInitData) {
        emit(CalculateBlocLoading());
        try {
          List<SymbolCase> symbolList = await checkSaveCoin();
          _coin1Id = symbolList[0];
          _coin2Id = symbolList[1];
          emit(CalculateBlocLoaded(symbolcase: symbolList));
        } catch (_) {
          emit(CalculateBlocError());
        }
      } else if (event is PressButton) {
        emit(CalculateBlocLoading());
        _buttonPressed(event.input);
        final List<String> output = [_output, _output2];
        emit(CalculatePressed(outputCase: output));
      } else if (event is PressChangeCoin) {
        emit(CalculateBlocLoading());
        switch (event.item) {
          case '0':
            var coinId = await Navigator.push(
              event.context,
              MaterialPageRoute(builder: (context) => CryptoSearchPage('')),
            );
            if (coinId == '') {
              coinId = _coin1Id.symbolData.id;
            }

            SharedPreferencesHelper.setString('coinId1', coinId);
            final result = await fetchMarketData(coinId);
            _coin1Id = result!;
            break;
          case '1':
            var coinId = await Navigator.push(
              event.context,
              MaterialPageRoute(builder: (context) => CryptoSearchPage('')),
            );
            if (coinId == '') {
              coinId = _coin2Id.symbolData.id;
            }

            SharedPreferencesHelper.setString('coinId2', coinId);
            final result = await fetchMarketData(coinId);
            _coin2Id = result!;
        }
        emit(CalculateBlocLoaded(symbolcase: [_coin1Id, _coin2Id]));
      } else if (event is UpdownCoin) {
        SymbolCase temp = _coin1Id;
        _coin1Id = _coin2Id;
        _coin2Id = temp;
        emit(CalculateUpDownLoaded(
            symbolcase: [_coin1Id, _coin2Id], outputList: [_output, _output2]));
      } else {
        return;
      }
    });
  }

  Future<List<SymbolCase>> checkSaveCoin() async {
    final coin1Id = await getCoinData('coinId1', 'bitcoin');
    final coin2Id = await getCoinData('coinId2', 'ethereum');
    return [coin1Id, coin2Id];
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
        return parseResponseData(jsonDecode(response.body));
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      debugPrint('Error occurred: $error');
      return null;
    }
  }

  Future<SymbolCase> getCoinData(String coinId, String defaultCoin) async {
    String coin = await SharedPreferencesHelper.getString(coinId);
    if (coin == '') {
      coin = defaultCoin;
    }
    final coinData = await fetchMarketData(coin);
    return coinData!;
  }

  SymbolCase? parseResponseData(List<dynamic> data) {
    if (data.isNotEmpty) {
      final item = data[0];
      final id = item['id'];
      final symbol = item['symbol'];
      final name = item['name'];
      final image = item['image'];
      final currentPrice = item['current_price'];
      final changePrice = item['price_change_24h']; //變化的美元
      final changePercent = item["last_updated"]; //變化的百分比
      final trick = Trickcrypto(symbol, id, name, image);

      return SymbolCase(trick, currentPrice, changePercent, changePrice);
    } else {
      debugPrint('No data received');
      return null;
    }
  }

  void _buttonPressed(String buttonText) {
    switch (buttonText) {
      case "⌫":
        _output = _output = _output.substring(0, _output.length - 1);
        _num1 = 0.0;
        _num2 = 0.0;
        debugPrint(_output);
        if (_output == '') {
          _output = '0';
        }

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
    _output2 = (double.parse(_output) * (_coin1Id.price / _coin2Id.price))
        .toStringAsFixed(4);

    if (_output == '0') {
      _output2 = '0';
    }
  }
}
