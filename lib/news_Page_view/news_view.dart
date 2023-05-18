import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_project/bloc/bloc/news_Bloc/news_bloc.dart';
import 'package:crypto_project/extension/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../cubit/image_cubit_cubit.dart';
import '../routes.dart';
import 'new_headerTopic.dart';
import 'news_cell_view.dart';
import 'news_header_view.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final TextEditingController _searchController = TextEditingController();
  late NewsBloc _newsBloc;
  final HeaderTopic _headerTopic = HeaderTopic('crypto', true);
  String googleurl = '';
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black, // 設置容器的背景顏色
        child: // 在這裡添加您的 UI 元素
            Scaffold(
          body: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                    child: Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.account);
                                print('push');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: googleurl == ''
                                        ? Colors.black
                                        : Colors.white,
                                    width: 2.0,
                                  ),
                                ),
                                child: googleurl != ''
                                    ? ClipOval(
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          imageUrl: googleurl,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.person_rounded),
                                        ),
                                      )
                                    : const Icon(Icons.person_rounded),
                              ),
                            )),
                        Expanded(
                          flex: 10,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: TextField(
                              controller: _searchController,
                              onChanged: null,
                              decoration: InputDecoration(
                                labelText: 'Search',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    if (_searchController.text != "") {
                                      _searchArticles(_searchController.text);
                                    }
                                  },
                                  icon: const Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
              Flexible(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 3),
                    color: Colors.white,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: _headerTopic.resultData.length,
                      itemBuilder: (context, index) {
                        List<HeaderTopic> topicList = _headerTopic.resultData;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  _searchArticles(topicList[index].topic);
                                  _onHeaderTopicSelected(index);
                                });
                              },
                              child: topicList[index].select
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.red,
                                            width: 2.5,
                                          ),
                                        ),
                                      ),
                                      child: CustomText(
                                        textContent: topicList[index].topic,
                                        textColor: Colors.red,
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.centerLeft,
                                      child: CustomText(
                                        textContent: topicList[index].topic,
                                        textColor: Colors.grey,
                                      ),
                                    )),
                        );
                      },
                    ),
                  )),
              Expanded(
                flex: 14,
                child: BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if (state is NewsInitial) {
                      return const Center(
                        child: Text('Wait fetch news'),
                      );
                    } else if (state is NewsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is NewsLoaded) {
                      return ListView.builder(
                        itemCount: state.articles.length,
                        itemBuilder: (context, index) {
                          final news = state.articles[index];
                          return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.newsDetail,
                                    arguments: news);
                              },
                              child: index == 0
                                  ? NewsHeaderView(news.image, news.title)
                                  : BlocProvider(
                                      create: (context) => ImageCubit(),
                                      child: NewsCellView(news.image,
                                          news.title, news.publishedAt)));
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('Failed to fetch news'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _newsBloc = context.read<NewsBloc>();
    _newsBloc.add(FetchArtcle());
    _headerTopic.topicListProperty();
  }


  void _onHeaderTopicSelected(int index) {
    setState(() {
      _headerTopic.changeResultData(index);
    });
  }

  void _searchArticles(String query) {
    _newsBloc.add(SearchArtcle(query));
  }
}
