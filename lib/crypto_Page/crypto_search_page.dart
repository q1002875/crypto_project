import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../extension/custom_text.dart';

class CryptoSearchPage extends StatefulWidget {
  String userid;
  CryptoSearchPage(this.userid, {super.key});

  @override
  State<CryptoSearchPage> createState() => _CryptoSearchPageState();
}

// 搜尋完要存到mongo

class _CryptoSearchPageState extends State<CryptoSearchPage> {
//  late List<String> data ;

  // Future<String> getEthereumInfo() async {
  //   const String apiUrl =
  //       'https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol=ETH';
  //   const String apiKey = '6e35c3bf-1346-4a87-9bae-25fe6ea51136';

  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'X-CMC_PRO_API_KEY': apiKey,
  //   };

  //   final response = await http.get(Uri.parse(apiUrl), headers: headers);

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     debugPrint(data.toString());
  //     return data;
  //   } else {
  //     return '';
  //     debugPrint(
  //         'Failed to get Ethereum info. Error code: ${response.statusCode}');
  //   }
  // }

  // Future<String> imaaaaaa(String symbol) async {
  //   const api =
  //       'https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol=ETH&CMC_PRO_API_KEY=6e35c3bf-1346-4a87-9bae-25fe6ea51136';
  //   final data = httpService(baseUrl: api);
  //   final response = await data.getJson();
  //   debugPrint(response.toString());
  //   return response;
  // }

  // Future<String> iconImage(String symbol) async {
  //   var url = Uri.parse(
  //       'https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol=ETH&CMC_PRO_API_KEY=6e35c3bf-1346-4a87-9bae-25fe6ea51136');
  //   var headers = {
  //     'Host': '',
  //     'X-CMC_PRO_API_KEY': '6e35c3bf-1346-4a87-9bae-25fe6ea51136',
  //   };
  //   debugPrint('獲取圖示');
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     debugPrint(response.toString());
  //     // var response = await http.get(url);
  //     debugPrint(response.body);
  //     var data = jsonDecode(response.body)['data'][symbol]['logo'];
  //     // return data.toString();
  //     return data;
  //   } else {
  //     debugPrint('fail');
  //     return '';
  //   }
  // }

  Future<List<Trickcrypto>> fetchSymbols() async {
    final response = await http
        .get(Uri.parse('https://api.binance.com/api/v3/exchangeInfo'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final symbols =
          List<String>.from(data['symbols'].map((symbol) => symbol['symbol']));
      String filterKeyword = 'usdt';
      List<String> filteredList = symbols.where((item) {
        return item.toLowerCase().contains(filterKeyword.toLowerCase());
      }).toList();
      List<Trickcrypto> filtered = [];

      for (var element in filteredList) {
        filtered.add(Trickcrypto(element));
      }

      // filteredList.map((e) =>
      //   filtered.add(trickcrypto(e))
      // );
      return filtered;
    } else {
      throw Exception('Failed to fetch symbols');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // iconImage('ETH');
    // getEthereumInfo();
  }

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
                  return
                      // Text(symbol);
                      MyListView(symbol);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )));
  }
}

class MyListView extends StatefulWidget {
  List<Trickcrypto> data;
  MyListView(this.data, {super.key});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  List<Trickcrypto> dataList = [];
  int loadedCount = 20; // 初始加载的数量
  bool isLoading = false;
  String searchKeyword = '';
  final bool _isToggled = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // 模拟异步加载数据
    await Future.delayed(const Duration(seconds: 1));

    // 模拟从服务器获取数据
    List<Trickcrypto> newData = widget.data;

    setState(() {
      dataList.clear();
      // 将新数据添加到现有数据列表中
      dataList.addAll(newData.getRange(0, loadedCount));

      // 增加加载的数量
      loadedCount += 20;

      // 停止加载状态
      isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    List<Trickcrypto> filteredList = dataList.where((item) {
      return item.coin.toLowerCase().contains(searchKeyword.toLowerCase());
    }).toList();

    return Scaffold(
        body: Column(
      children: [
        TextField(
          onChanged: (value) {
            setState(() {
              searchKeyword = value;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search',
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
                  // 显示数据项
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
          Flexible(flex: 1, child: Image.asset('assets/cryptoIcon.png')),
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
                  String modifiedString =
                      data.coin.toLowerCase();
                  setState(() {
                    
                  int index = dataList
                        .indexWhere((element) => element.coin == data.coin);
                    if (data.isAdd) {
                      if (index >= 0) {
                        dataList[index].isAdd = false;
                        debugPrint('$modifiedString移除');
                        // 移除資料
                      }
                    } else {
                      if (index >= 0) {
                        dataList[index].isAdd = true;
                      }
                      debugPrint('$modifiedString新增');
                      // 新增貨幣
                    }
                  });
                },
              )),
        ],
      ),
    );
  }
}

class Trickcrypto {
  String coin;
  bool isAdd = false;
  Trickcrypto(this.coin);
}
