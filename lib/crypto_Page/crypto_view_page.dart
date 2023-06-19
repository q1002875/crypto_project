import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_project/account_Page/account_view.dart';
import 'package:crypto_project/crypto_Page/bloc/cyrpto_view_bloc_bloc.dart';
import 'package:crypto_project/crypto_Page/crypto_search_page.dart';
import 'package:crypto_project/extension/custom_alerdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../account_Page/login/bloc/login_bloc.dart';
import '../database_mongodb/maongo_database.dart';
import '../extension/SharedPreferencesHelper.dart';
import '../extension/ShimmerText.dart';
import '../extension/custom_text.dart';
import '../extension/gobal.dart';
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
  // var searchCrypto = '';
  List<SymbolCase> tickData = [];
  late String localuserid = '';
  late CyrptoViewBlocBloc _cryptoBloc;

  bool edit = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text('Crypto List'),
          actions: <Widget>[
            localuserid != ''
                ? IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      Navigator.pushNamed(context, Routes.cryptoSearch,
                              arguments: localuserid)
                          .then((value) {
                        // "value" 是新页面返回的数据，您可以在这里处理
                        if (value != null) {
                          _cryptoBloc.add(FetchCryptoProcess());
                        }
                      });
                    },
                  )
                : Container(),
            tickData != [] && localuserid != ''
                ? IconButton(
                    icon:
                        edit ? const Icon(Icons.check) : const Icon(Icons.edit),
                    onPressed: () async {
                      if (edit) {
                        final updatedCryptoList =
                            tickData.map((e) => e.symbolData.id).toList();
                        await mongodb.updateDocument({
                          'userId': localuserid
                        }, {
                          'userId': localuserid,
                          'crypto': updatedCryptoList
                        }, ConnectDbName.crypto, '');
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleConfirmDialog(
                              content: 'Edit Finish',
                              onConfirmed: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      }
                      setState(() {
                        edit = !edit;
                      });

                      _refreshData();
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

  Widget editListviewCell(SymbolCase data) {
    final image = data.symbolData.image;
    final symbol = data.symbolData.coin;

    return Container(
      key: Key(data.symbolData.id),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(8),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const ShimmerBox(),
                  imageUrl: image,
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/cryptoIcon.png'),
                ),
              )),
          Flexible(
              flex: 4,
              child: Center(
                child: CustomText(
                  align: TextAlign.start,
                  textContent: '${symbol.toUpperCase()}USDT',
                  textColor: Colors.black,
                  fontSize: 14,
                ),
              )),
          const Flexible(flex: 2, child: Center(child: Icon(Icons.menu))),
        ],
      ),
    );
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
          case CryptoPrecess.loadData:
            tickData = fetchTickData;
            return edit
                ? _editContent(fetchTickData)
                : _mainContent(fetchTickData);

          //  _

          case CryptoPrecess.noCreateCoin:
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

          case CryptoPrecess.noUserId:
            return Center(
                child: TextButton(
              onPressed: () {
                // Navigator.pushNamed(context, Routes.account);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BlocProvider(
                          create: (context) => AuthenticationBloc(),
                          child: AccountPage(
                            needtologin: true,
                          ))),
                );
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

  Widget _editContent(List<SymbolCase> items) {
    return ReorderableListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return Dismissible(
          key: Key(item.symbolData.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart ||
                direction == DismissDirection.startToEnd) {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm"),
                    content: const Text(
                        "Are you sure you wish to delete this item?"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("DELETE")),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("CANCEL"),
                      ),
                    ],
                  );
                },
              );
            }
            return false;
          },
          onDismissed: (direction) {
            setState(() {
              items.removeAt(index);
              ////刪除
            });
          },
          child: editListviewCell(item),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
        });
      },
    );
  }

  Widget _mainContent(List<SymbolCase> tickData) {
    return RefreshIndicator(
      onRefresh: _refreshData, // 在这里指定你的数据刷新方法
      child: tickData.isNotEmpty
          ? ListView(
              scrollDirection: Axis.vertical,
              children: [
                ListView.builder(
                  shrinkWrap: true, // Add this
                  physics: const NeverScrollableScrollPhysics(), // And this
                  itemCount: tickData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LineChartPage(tickData[index].symbolData),
                          ),
                        );
                      },
                      child: listviewCell(tickData[index]),
                    );
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.cryptoSearch,
                            arguments: localuserid)
                        .then((value) {
                      // "value" 是新页面返回的数据，您可以在这里处理
                      if (value != null) {
                        _cryptoBloc.add(FetchCryptoProcess());
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 0),
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: screenHeight / 10,
                    color: Colors.white,
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.blue,
                          ),
                          CustomText(
                            textContent: 'Add Crypto',
                            textColor: Colors.blue,
                            fontSize: 16,
                          )
                        ]),
                  ),
                )
              ],
            )
          : const SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: ShimmerBox(),
            ),
    );
  }

  Future<void> _refreshData() async {
    _cryptoBloc.add(FetchCryptoProcess());
  }
}
