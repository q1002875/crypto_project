import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../api_model/news_totalModel.dart';

class NewsDetail extends StatelessWidget {
  final ArticleModel news;

  const NewsDetail({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebViewContainer(news.url);
  }
}

class WebViewContainer extends StatefulWidget {
  final String url;

  const WebViewContainer(this.url, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  final UniqueKey _key = UniqueKey();
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'News',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          WebView(
            key: _key,
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
          _isLoading ? const LinearProgressIndicator() : Container()
        ],
      ),
    );
  }
}
