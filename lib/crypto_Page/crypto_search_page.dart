import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_project/api_model/crypto_coinModel.dart';
import 'package:crypto_project/extension/ShimmerText.dart';
import 'package:crypto_project/extension/gobal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String id;
  String coin;
  String name;
  String image;
  bool isAdd = false;
  Trickcrypto(this.coin, this.id, this.name, this.image);
}

class _CryptoSearchPageState extends State<CryptoSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const CustomText(
            textContent: '',
            textColor: Colors.white,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (widget.userid == '') {
                Navigator.pop(context, '');
              }
              Navigator.pop(context, '更新');
            },
          ),
        ),
        body: Container(
            color: Colors.white,
            child:
                // const MyListView()

                FutureBuilder(
              future: loadLocalJson(),
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

  Future<List<Trickcrypto>> loadLocalJson() async {
    final String jsonString =
        await rootBundle.loadString('assets/coindata.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    List<Trickcrypto> result = [];
    // Now you can use jsonData in your code.
    for (final item in jsonData) {
      result.add(Trickcrypto('${item['symbol']}', '${item['id']}',
          '${item['name']}', '${item['image']}'));
      debugPrint(
          'ID: ${item['id']}, Symbol: ${item['symbol']}, Name: ${item['name']}');
    }
    return result;
  }
}

class _MyListViewState extends State<MyListView> {
  List<String> mongoCryptoList = [];
  List<Trickcrypto> dataList = [];
  int loadedCount = 40; // 初始加载的数量
  bool isLoading = false;
  String searchKeyword = '';
  @override
  Widget build(BuildContext context) {
    List<Trickcrypto> filteredList = dataList.where((item) {
      return item.name.toLowerCase().contains(searchKeyword.toLowerCase());
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
      final isAdded = mongoCryptoList.contains(item.id);
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
    return GestureDetector(
        onTap: () {
          if (widget.userId == '') {
            Navigator.pop(context, data.id);
          }
        },
        child: Container(
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
                      imageUrl: data.image,
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/cryptoIcon.png'),
                    ),
                  )),
              Flexible(
                  flex: 4,
                  child: CustomText(
                    textContent: '${data.name}(${data.coin})',
                    textColor: Colors.black,
                    fontSize: 20,
                  )),
              widget.userId != ''
                  ? Flexible(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(data.isAdd ? Icons.check : Icons.add),
                        onPressed: () {
                          setState(() {
                            String showText = '';
                            final index = dataList
                                .indexWhere((element) => element.id == data.id);
                            if (index >= 0) {
                              dataList[index].isAdd = !data.isAdd;

                              dataList[index].isAdd
                                  ? showText = '新增${dataList[index].id}'
                                  : showText = '刪除${dataList[index].id}';
                            }
                            final updatedCryptoList = dataList
                                .where((element) => element.isAdd)
                                .map((e) => e.id)
                                .toList();

                            mongodb.updateDocument({
                              'userId': widget.userId
                            }, {
                              'userId': widget.userId,
                              'crypto': updatedCryptoList
                            }, ConnectDbName.crypto, showText);
                          });
                        },
                      ))
                  : Flexible(flex: 1, child: Container())
            ],
          ),
        ));
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
