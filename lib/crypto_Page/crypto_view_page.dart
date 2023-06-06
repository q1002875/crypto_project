import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_project/crypto_Page/bloc/cyrpto_view_bloc_bloc.dart';
import 'package:crypto_project/crypto_Page/crypto_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../extension/SharedPreferencesHelper.dart';
import '../extension/ShimmerText.dart';
import '../extension/custom_text.dart';
import '../extension/gobal.dart';
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
  // var searchCrypto = '';
  List<SymbolCase> tickData = [];
  late String localuserid = '';
  late CyrptoViewBlocBloc _cryptoBloc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Crypto List'),
          actions: <Widget>[
            tickData != []
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // ChartArguments
                      Navigator.pushNamed(context, Routes.cryptoedit,
                          arguments: ChartArguments(tickData, localuserid));
                    },
                  )
                : Container(),
            localuserid != ''
                ? IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.cryptoSearch,
                          arguments: localuserid);
                    },
                  )
                : Container(),
          ],
        ),
        body: BlocBuilder<CyrptoViewBlocBloc, CyrptoViewBlocState>(
            builder: (context, state) {
          return _buildContent(context, state);
        }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  // //先拿到內建
  Future<void> getUserId() async {
    localuserid = await SharedPreferencesHelper.getString('userId');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    _cryptoBloc = BlocProvider.of<CyrptoViewBlocBloc>(context);
    _cryptoBloc.add(FetchCryptoProcess());
  }

  Widget listviewCell(SymbolCase data) {
    final image = data.symbolData.image;
    final symbol = data.symbolData.coin;

    return Container(
      height: screenHeight / 9,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomText(
                    align: TextAlign.right,
                    textContent: data.price.toStringAsFixed(4).toString(),
                    textColor: Colors.black,
                    fontSize: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        align: TextAlign.right,
                        textContent: data.changePrice > 0
                            ? '+${data.changePrice.toStringAsFixed(3)}'
                            : data.changePrice.toStringAsFixed(3).toString(),
                        textColor:
                            data.changePrice > 0 ? Colors.green : Colors.red,
                        fontSize: 13,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        align: TextAlign.right,
                        textContent: data.changePercent > 0
                            ? '+${data.changePercent.toStringAsFixed(2)}%'
                            : '${data.changePercent.toStringAsFixed(2)}%',
                        textColor:
                            data.changePercent > 0 ? Colors.green : Colors.red,
                        fontSize: 13,
                      ),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, CyrptoViewBlocState state) {
    switch (state.runtimeType) {
      case CyrptoViewBlocLoading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case CyrptoViewBlocLoaded:
        final data = (state as CyrptoViewBlocLoaded);

        final fetchInfo = data.data;
        final fetchTickData = data.tickData;
        switch (fetchInfo) {
          case cryptoPrcess.loadData:
            // return const MyList();
            tickData = fetchTickData;
            return _mainContent(fetchTickData);

          case cryptoPrcess.noCreateCoin:
            return Center(
                child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.cryptoSearch,
                    arguments: localuserid);
              },
              child: const CustomText(
                textContent: 'Add New CryptoCoin',
                textColor: Colors.blueGrey,
              ),
            ));

          case cryptoPrcess.noUserId:
            return Center(
                child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.account);
              },
              child: const CustomText(
                textContent: 'Not yet login',
                textColor: Colors.blueGrey,
              ),
            ));
        }

      case CyrptoViewBlocError:
        return const Center(
          child: Center(
            child: Text('Load Error'),
          ),
        );
    }
    return Container();
  }

  Widget _mainContent(List<SymbolCase> tickData) {
    return RefreshIndicator(
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
    );
  }

  // void repeatPrice() {
  //   Timer.periodic(const Duration(seconds: 15), (Timer timer) {
  //     tickData.clear();
  //     fetchMarketData(searchCrypto);
  //   });
  // }

  Future<void> _refreshData() async {
    _cryptoBloc.add(FetchCryptoProcess());
  }
}
