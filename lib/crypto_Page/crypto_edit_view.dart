import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../extension/ShimmerText.dart';
import '../extension/custom_text.dart';
import '../extension/gobal.dart';
import '../routes.dart';
import 'crypto_view_page.dart';

class CryptoEdit extends StatefulWidget {
  final ChartArguments data;

  const CryptoEdit(this.data, {super.key});

  @override
  _CryptoEditState createState() => _CryptoEditState();
}

class _CryptoEditState extends State<CryptoEdit> {
  List<SymbolCase> _items = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          textContent: 'Edit',
          textColor: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              () => Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _items[index];

          return editListviewCell(item);
        },
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
        },
      ),
    ));
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
                // color: Colors.amber,
                margin: const EdgeInsets.all(8),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const ShimmerBox(),
                  imageUrl: image,
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/cryptoIcon.png'),
                ),
              )),
          // const SizedBox(width: 5),
          Flexible(
              flex: 4,
              child: Center(
                // color: Colors.blueGrey,
                // alignment: Alignment.centerLeft,
                child: CustomText(
                  align: TextAlign.start,
                  textContent: '${symbol.toUpperCase()}USDT',
                  textColor: Colors.black,
                  fontSize: 14,
                ),
              )),
          const Flexible(
              flex: 2,
              child: Center(
                  // color: Colors.pink,
                  // alignment: Alignment.centerLeft,
                  child: Icon(Icons.menu))),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _items = widget.data.trickcrypto;
  }
}
