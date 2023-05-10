import 'package:crypto_project/extension/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/news_bloc.dart';
import '../cubit/image_cubit_cubit.dart';
import '../extension/custom_page_route.dart';
import 'new_headerTopic.dart';
import 'news_cell_detail.dart';
import 'news_cell_view.dart';
import 'news_header_view.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _searchController = TextEditingController();
  late NewsBloc _newsBloc;
  final HeaderTopic _headerTopic = HeaderTopic('crypto', true);
  @override
  void initState() {
    super.initState();
    _newsBloc = context.read<NewsBloc>();
    _newsBloc.add(FetchArtcle());
    _headerTopic.topicListProperty();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchArticles(String query) {
    _newsBloc.add(SearchArtcle(query));
  }

  void _onHeaderTopicSelected(int index) {
    setState(() {
      _headerTopic.changeResultData(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          color: Colors.white, // 設置容器的背景顏色
          child: // 在這裡添加您的 UI 元素
              Scaffold(
            // appBar: AppBar(
            //   title: const Text(''),
            // ),
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
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              child: const Icon(Icons.person_rounded),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              // decoration: BoxDecoration(
                              //     color:const Color.fromARGB(129, 133, 161, 175),
                              //     shape: BoxShape.rectangle,
                              //     borderRadius: BorderRadius.circular(20.0)),
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
                    flex: 1,
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _searchArticles(topicList[index].topic);
                                  _onHeaderTopicSelected(index);
                                });
                              },
                              child: topicList[index].select
                                  ? Container(
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
                                  : CustomText(
                                      textContent: topicList[index].topic,
                                      textColor: Colors.grey,
                                    ),
                            ),
                          );
                        },
                      ),
                    )),
                Expanded(
                  flex: 12,
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
                                  Navigator.of(context).push(CustomPageRoute(
                                      builder: (_) => NewsDetail(
                                            news: news,
                                          )));
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
          ))
    ;
  }
}
