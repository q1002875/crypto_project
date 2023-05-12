import 'package:crypto_project/extension/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../api_model/news_totalModel.dart';

class NewsDetail extends StatelessWidget {
  final ArticleModel news;
  const NewsDetail({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final Uri myUri = Uri.parse(news.url);
    return WebViewContainer(myUri);
  }
}

class WebViewContainer extends StatefulWidget {
  final Uri url;
  const WebViewContainer(this.url, {super.key});
  @override
  // ignore: no_logic_in_create_state
  createState() => _WebViewContainerState(url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  final _url;
  final _key = UniqueKey();
  _WebViewContainerState(this._url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber,
        appBar: AppBar(title:const CustomText(textContent:'News',textColor: Colors.white,)),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: widget.url.toString()))
          ],
        ));
  }
}
