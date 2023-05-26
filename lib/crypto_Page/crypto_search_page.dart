import 'dart:convert';

import 'package:crypto_project/api_model/crypto_coinModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../database_mongodb/maongo_database.dart';
import '../extension/custom_text.dart';
import '../main.dart';

class CryptoSearchPage extends StatefulWidget {
  String userid;
  CryptoSearchPage(this.userid, {super.key});

  @override
  State<CryptoSearchPage> createState() => _CryptoSearchPageState();
}

class MyListView extends StatefulWidget {
  List<Trickcrypto> data;
  String userId;
  MyListView(this.userId, this.data, {super.key});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class Trickcrypto {
  String coin;
  bool isAdd = false;
  Trickcrypto(this.coin);
}

// 搜尋完要存到mongo

class _CryptoSearchPageState extends State<CryptoSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const CustomText(
          textContent: 'crypto search',
          textColor: Colors.white,
        )),
        body: Container(
            color: Colors.white,
            child:
                // const MyListView()

                FutureBuilder(
              future: fetchSymbols(),
              builder: (context, snapshot) {
                final symbol = snapshot.data;
                if (symbol != null) {
                  return MyListView(widget.userid, symbol);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )));
  }

  Future<List<Trickcrypto>> fetchSymbols() async {
    final response = await http
        .get(Uri.parse('https://api.binance.com/api/v3/exchangeInfo'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final symbols =
          List<String>.from(data['symbols'].map((symbol) => symbol['symbol']));
      String filterKeyword = 'usdt';

      return symbols
          .where((element) =>
              element.toLowerCase().contains(filterKeyword.toLowerCase()))
          .map((element) => Trickcrypto(element))
          .toList();
    } else {
      throw Exception('Failed to fetch symbols');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

class _MyListViewState extends State<MyListView> {
  List<String> mongoCryptoList = [];
  List<Trickcrypto> dataList = [];
  int loadedCount = 20; // 初始加载的数量
  bool isLoading = false;
  String searchKeyword = '';
  @override
  Widget build(BuildContext context) {
    List<Trickcrypto> filteredList = dataList.where((item) {
      return item.coin.toLowerCase().contains(searchKeyword.toLowerCase());
    }).toList();

    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchKeyword = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0), // 使用圓角半徑設置橢圓形狀
              ),
            ),
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: _onNotification,
            child: ListView.builder(
              itemCount: searchKeyword != ''
                  ? filteredList.length
                  : dataList.length + 1, // 加1是为了显示加载更多的提示
              itemBuilder: (context, index) {
                if (index < dataList.length && searchKeyword == '') {
                  //显示数据项
                  return listviewCell(dataList[index], index);
                } else if (searchKeyword != '') {
                  return listviewCell(filteredList[index], index);
                } else {
                  // 显示加载更多的提示
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          height: 4,
        )
      ],
    ));
  }

  Future<void> fetchData() async {
    // 根據 loadedCount 取得新資料的子列表
    final newData = widget.data.sublist(0, loadedCount);
    // 更新 newData 中每個項目的 isAdd 欄位
    final updatedDataList = newData.map((item) {
      final isAdded = mongoCryptoList.contains(item.coin);
      item.isAdd = isAdded;
      return item;
    }).toList();
    setState(() {
      // 清空現有的 dataList
      dataList.clear();
      // 將更新後的項目添加到 dataList 中
      dataList.addAll(updatedDataList);
      // 增加已載入的數量
      loadedCount += 20;
      // 停止加載狀態
      isLoading = false;
    });
  }

  Future<UserCryptoData?> fetchMongoData() async {
    final cryptoData =
        await mongodb.getUserCryptoData(widget.userId, ConnectDbName.crypto);
    if (cryptoData != null) {
      mongoCryptoList = cryptoData.crypto;
      debugPrint('回傳回來得coin list:$cryptoData');
      //fetch data
    } else {
      mongodb.insertDocument({'userId': widget.userId}, ConnectDbName.crypto);
    }
    return null;
  }

  Future<void> init() async {
    try {
      await fetchMongoData();
      await fetchData();
      // 所有異步操作完成後的處理
      // ...
    } catch (error) {
      // 異步操作中發生錯誤的處理
      // ...
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Widget listviewCell(Trickcrypto data, int index) {
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 1,
            child: Image.asset(
              'assets/crypto/${data.coin.replaceAll('USDT', '')}.png',
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                // Return any widget that you want to display when the image cannot be loaded
                return Image.asset('assets/cryptoIcon.png');
              },
            ),
          ),
          Flexible(
              flex: 4,
              child: CustomText(
                textContent: data.coin,
                textColor: Colors.black,
                fontSize: 20,
              )),
          Flexible(
              flex: 1,
              child: IconButton(
                icon: Icon(data.isAdd ? Icons.check : Icons.add),
                onPressed: () {
                  setState(() {
                    String showText = '';
                    final index = dataList
                        .indexWhere((element) => element.coin == data.coin);
                    if (index >= 0) {
                      dataList[index].isAdd = !data.isAdd;

                      dataList[index].isAdd
                          ? showText = '新增${dataList[index].coin}'
                          : showText = '刪除${dataList[index].coin}';
                    }
                    final updatedCryptoList = dataList
                        .where((element) => element.isAdd)
                        .map((e) => e.coin)
                        .toList();

                    mongodb.updateDocument(
                        {'userId': widget.userId},
                        {'userId': widget.userId, 'crypto': updatedCryptoList},
                        ConnectDbName.crypto,
                        showText);
                  });
                },
              )),
        ],
      ),
    );
  }

  bool _onNotification(ScrollNotification notification) {
    if (!isLoading &&
        notification.metrics.pixels == notification.metrics.maxScrollExtent) {
      // 当滚动到底部时触发加载更多数据
      setState(() {
        isLoading = true;
      });
      fetchData();
    }
    return false;
  }
}
