import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../database_mongodb/maongo_database.dart';
import '../extension/custom_text.dart';

class CryptoSearchPage extends StatefulWidget {
  String userid;
  CryptoSearchPage(this.userid, {super.key});

  @override
  State<CryptoSearchPage> createState() => _CryptoSearchPageState();
}

// 搜尋完要存到mongo

class _CryptoSearchPageState extends State<CryptoSearchPage> {

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
                      MyListView(widget.userid,symbol);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )));
  }
}

class MyListView extends StatefulWidget {
  List<Trickcrypto> data;
  String userId ;
  MyListView(this.userId, this.data, {super.key});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
   MongoDBConnection mongodb = MongoDBConnection();
  List<Trickcrypto> dataList = [];
  int loadedCount = 20; // 初始加载的数量
  bool isLoading = false;
  String searchKeyword = '';
  @override
  void initState() {
    super.initState();
    Future<void> connectMongo() async {await mongodb.connect();}
    connectMongo();
    fetchData();
  }

  Future<void> connectMongo() async {mongodb.connect();}
  Future<void> fetchData() async {
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

                        // mongodb.deleteOne('21321', '', ConnectDbName.crypto);
                        // 移除資料
                      }
                    } else {
                      if (index >= 0) {
                        dataList[index].isAdd = true;
                      
                        // repositorty.addSubscripCoin({'123':'123'});
                      }
                    
                      debugPrint('$modifiedString新增');
                      // 新增貨幣
                    }
                     //庚熹
                        //  mongodb.insertDocument(
                        // {'userId': widget.userId}, ConnectDbName.crypto);
                       
                      //  mongodb.deleteOne('userId', widget.userId, ConnectDbName.crypto);
                       final d = dataList.where((element) =>  element.isAdd == true).map((e) => e.coin);
                       String json = jsonEncode(d.toList());
                        // mongodb.insertDocument(
                        //   { 'userid':widget.userId,
                        //     'crypto': json}, ConnectDbName.crypto);
                    // mongodb.updateDocument(
                    //     {'userId': widget.userId},
                    //     {'userId':'123123132'},
                    //     ConnectDbName.crypto);


                  final returnresult =  mongodb.updateDocument({'userId':widget.userId}, {'userId':widget.userId,'crypto':json}, ConnectDbName.crypto);
                   // ignore: unrelated_type_equality_checks

                   debugPrint('上傳$returnresult') ;
                  //  returnresult == true ? debugPrint('上傳成功') : debugPrint('上傳失敗');
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
