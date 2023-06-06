import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../database_mongodb/maongo_database.dart';
import '../../extension/SharedPreferencesHelper.dart';
import '../../main.dart';
import '../crypto_search_page.dart';
import '../crypto_view_page.dart';

part 'cyrpto_view_bloc_event.dart';
part 'cyrpto_view_bloc_state.dart';

enum cryptoPrcess { loadData, noCreateCoin, noUserId }

class CyrptoViewBlocBloc
    extends Bloc<CyrptoViewBlocEvent, CyrptoViewBlocState> {
  //  var showprice = '';
  var searchCrypto = '';

  List<SymbolCase> tickData = [];
  // late String userid = '';
  CyrptoViewBlocBloc() : super(CyrptoViewBlocInitial()) {
    on<CyrptoViewBlocEvent>((event, emit) async {
      if (event is FetchCryptoProcess) {
        emit(CyrptoViewBlocLoading());
        final userid = await getUserId();
        // ignore: unrelated_type_equality_checks
        if (userid != '') {
          //擊者做
          final cryptolist = await getLowercaseCryptoList(userid);
          if (cryptolist.isNotEmpty) {
            //接者做
            await fetchMarketDataForCryptos(cryptolist);
            return emit(CyrptoViewBlocLoaded(
              data: cryptoPrcess.loadData,
              tickData: tickData,
            ));
          } else {
            return emit(const CyrptoViewBlocLoaded(
              data: cryptoPrcess.noCreateCoin,
              tickData: [],
            ));
          }
        } else {
          return emit(const CyrptoViewBlocLoaded(
              data: cryptoPrcess.noUserId, tickData: []));
        }
      }
    });
  }

  Future<List<SymbolCase>> fetchMarketData(String p) async {
    tickData.clear();
    String url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$p&order=market_cap_desc&page=1&sparkline=false&locale=en';
    try {
      // 发送 GET 请求
      var response = await http.get(Uri.parse(url));

      // 检查响应状态码
      if (response.statusCode == 200) {
        // 解析响应数据
        var data = jsonDecode(response.body);
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
        return tickData;
        // setState(() {});
      } else {
        return [];
        debugPrint('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      return [];
      debugPrint('Error occurred: $error');
    }
  }

  Future<void> fetchMarketDataForCryptos(List<String> cryptoList) async {
    final cryptoString = cryptoList.join(',');
    await fetchMarketData(cryptoString);
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

  Future<List<String>> getLowercaseCryptoList(String userId) async {
    final cryptoData =
        await mongodb.getUserCryptoData(userId, ConnectDbName.crypto);
    if (cryptoData != null) {
      final cryptoList =
          cryptoData.crypto.map((element) => element.toLowerCase()).toList();
      return cryptoList;
    } else {
      debugPrint('cryptoData is null');
      return [];
    }
  }

  Future<void> getSharedDataStream() async {
    final userid = await getUserId(); //回傳沒有
    final cryptoList = await getLowercaseCryptoList(userid); //回傳還沒有新增貨幣
    await fetchMarketDataForCryptos(cryptoList); //回傳資料
  }

  Future<String> getUserId() async {
    final userId = await SharedPreferencesHelper.getString('userId');
    return userId;
  }
}
