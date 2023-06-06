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
  final bool _isLoading = false;

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
            // onPageStarted: (url) {
            //   setState(() {
            //     _isLoading = true;
            //   });
            // },
            // onPageFinished: (url) {
            //   setState(() {
            //     _isLoading = false;
            //   });
            // },
            // onWebResourceError: (error) {
            //   setState(() {
            //     _isLoading = false;
            //   });
            // },
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Center(
                  child: SizedBox(),
                )
        ],
      ),
    );
  }
}
