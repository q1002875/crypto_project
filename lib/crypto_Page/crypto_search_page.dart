import 'dart:convert';

import 'package:crypto_project/service_Api/coinbase_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../extension/custom_text.dart';
import '../http_server.dart';

class CryptoSearchPage extends StatefulWidget {
  String userid;
  CryptoSearchPage(this.userid, {super.key});

  @override
  State<CryptoSearchPage> createState() => _CryptoSearchPageState();
}

// 搜尋完要存到mongo

class _CryptoSearchPageState extends State<CryptoSearchPage> {
//  late List<String> data ;



Future<String> getEthereumInfo() async {
    const String apiUrl =
        'https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol=ETH';
    const String apiKey = '6e35c3bf-1346-4a87-9bae-25fe6ea51136';

final headers = {
  'Content-Type': 'application/json',
  'X-CMC_PRO_API_KEY': apiKey,

};


    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data.toString());
      return data;
    } else {
      return '';
      print('Failed to get Ethereum info. Error code: ${response.statusCode}');
    }
  }





  Future<String> imaaaaaa(String symbol) async {
    const api =
        'https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol=ETH&CMC_PRO_API_KEY=6e35c3bf-1346-4a87-9bae-25fe6ea51136';
    final data = httpService(baseUrl: api);
    final response = await data.getJson();
    print(response.toString());
    return response;
  }




Future<String> iconImage(String symbol) async {
    var url = Uri.parse(
        'https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol=ETH&CMC_PRO_API_KEY=6e35c3bf-1346-4a87-9bae-25fe6ea51136');
    var headers = {
      'X-CMC_PRO_API_KEY': '6e35c3bf-1346-4a87-9bae-25fe6ea51136',
    };
    final response = await http
        .get(url,headers: headers);
    
       print('獲取圖示');
      // var response = await http.get(url);
      print(response.body);
      var data = jsonDecode(response.body)['data'][symbol]['logo'];
      // return data.toString();
      return data;
    
  }



Future<List<String>> fetchSymbols() async {
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

      return filteredList;
    } else {
      throw Exception('Failed to fetch symbols');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // iconImage('ETH');
    getEthereumInfo();
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
            color: Colors.amber,
            child:
            // const MyListView()
            
            FutureBuilder(
              future: coinbaseApi.getcoinBaseImageReport(),
              builder: (context, snapshot) {
                final symbol = snapshot.data;
                if (symbol != null) {
              
                 return Text(symbol);
                //  MyListView(symbol);


                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
            
            
            ));
  }
}



class MyListView extends StatefulWidget {
  List<String> data ;
   MyListView(this.data,{super.key});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  List<String> dataList = [];
  int loadedCount = 20; // 初始加载的数量
  bool isLoading = false;
  String searchKeyword = '';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // 模拟异步加载数据
    await Future.delayed(const Duration(seconds: 1));

    // 模拟从服务器获取数据
    List<String> newData = widget.data;
    
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
    if (!isLoading && notification.metrics.pixels == notification.metrics.maxScrollExtent) {
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
     List<String> filteredList = dataList.where((item) {
      return item.toLowerCase().contains(searchKeyword.toLowerCase());
    }).toList();


    return Scaffold(
      // appBar: AppBar(
      //   title:  Text('dataList lenth${dataList.length}'),
      // ),
      body: Column(children: [
           TextField(
            onChanged: (value) {
              setState(() {
                searchKeyword = value;
              });
            },
            decoration:const InputDecoration(
              hintText: 'Search',
            ),
          ),
          Expanded(child:   NotificationListener<ScrollNotification>(
                onNotification: _onNotification,
                child: ListView.builder(
                  itemCount: searchKeyword != ''?filteredList.length :dataList.length + 1, // 加1是为了显示加载更多的提示
                  itemBuilder: (context, index) {
                    if (index < dataList.length && searchKeyword == '') {
                      // 显示数据项
                      return ListTile(
                        title: Text(dataList[index]),
                      );
                    } else if (searchKeyword != '') {
                      return ListTile(
                        title: Text(filteredList[index]),
                      );
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
      height: 1,
    )
           

      ],)
    );
  }
}


// import 'package:http/http.dart' as http;




