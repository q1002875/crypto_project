import 'package:crypto_project/bloc/bloc/news_Bloc/news_bloc.dart';
import 'package:crypto_project/extension/custom_text.dart';
import 'package:crypto_project/main.dart';

import '../common.dart';
import '../cubit/image_cubit_cubit.dart';
import '../database_mongodb/maongo_database.dart';
import '../extension/SharedPreferencesHelper.dart';
import '../extension/ShimmerText.dart';
import '../extension/gobal.dart';
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
  final FocusNode _focusNode = FocusNode();

  var tapSearch = false;

  String googleurl = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            color: Colors.black, // 設置容器的背景顏色
            child: // 在這裡添加您的 UI 元素
                Scaffold(
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text(
                        '側邊選單',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('首頁'),
                      onTap: () {
                        // 在這裡處理點擊首頁的動作
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('設定'),
                      onTap: () {
                        // 在這裡處理點擊設定的動作
                      },
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Flexible(
                    flex: tapSearch ? 0 : 3,
                    child: Flex(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        direction: Axis.vertical,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            color: Colors.blueGrey
                                .withOpacity(0.8), // Light red color,
                            width: double.infinity,
                            child: const CustomText(
                              textContent: 'News',
                              textColor: Colors.white,
                              fontSize: 38,
                              align: TextAlign.left,
                            ),
                          ),
                        ]),
                  ),
                  Flexible(
                    flex: tapSearch ? 7 : 2,
                    child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 0, bottom: 0),
                        child: Container(
                          color: Colors.white,
                          child: Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            direction: Axis.horizontal,
                            children: [
                              // Flexible(
                              //     flex: 2,
                              //     child: GestureDetector(
                              //       onTap: () {
                              //         // Navigator.pushNamed(context, Routes.account);
                              //         // print('push');
                              //       },
                              //       child: Container(
                              //         decoration: BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           border: Border.all(
                              //             color: googleurl == ''
                              //                 ? Colors.black
                              //                 : Colors.white,
                              //             width: 2.0,
                              //           ),
                              //         ),
                              //         child: googleurl != ''
                              //             ? ClipOval(
                              //                 child: CachedNetworkImage(
                              //                   placeholder: (context, url) =>
                              //                       const CircularProgressIndicator(),
                              //                   imageUrl: googleurl,
                              //                   errorWidget: (context, url,
                              //                           error) =>
                              //                       const Icon(
                              //                           Icons.person_rounded),
                              //                 ),
                              //               )
                              //             : const Icon(Icons.person_rounded),
                              //       ),
                              //     )),
                              Expanded(
                                child: Container(
                                  // height: screenHeight / 4,
                                  margin: const EdgeInsets.all(2),
                                  child: TextField(
                                    controller: _searchController,
                                    focusNode: _focusNode,
                                    onTap: () {
                                      setState(() {
                                        tapSearch = true;
                                      });
                                    },
                                    onEditingComplete: () {
                                      // 当TextField编辑完成时触发的操作
                                      // print('TextField 编辑完成：${_s.text}');
                                      // 在这里执行你希望的逻辑，比如提交表单、搜索等
                                      // 隐藏键盘
                                      setState(() {
                                        if (_searchController.text != "") {
                                          _searchArticles(
                                              _searchController.text);
                                        }
                                        tapSearch = false;
                                      });

                                      FocusScope.of(context).unfocus();
                                    },
                                    onChanged: null,
                                    decoration: InputDecoration(
                                      labelText: '',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          if (_searchController.text != "") {
                                            _searchArticles(
                                                _searchController.text);
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
                  ),
                  Flexible(
                      flex: tapSearch ? 3 : 2,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        color: Colors.white,
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: _headerTopic.resultData.length,
                          itemBuilder: (context, index) {
                            List<HeaderTopic> topicList =
                                _headerTopic.resultData;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _searchArticles(topicList[index].topic);
                                      _onHeaderTopicSelected(index);
                                    });
                                  },
                                  child: topicList[index].select
                                      ? Container(
                                          width: topicList[index].select
                                              ? screenWidth / 3
                                              : screenWidth / 5,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.withOpacity(
                                                0.8), // Light red color
                                            borderRadius: BorderRadius.circular(
                                                30.0), // Circular border
                                          ),
                                          child: CustomText(
                                            align: TextAlign.center,
                                            textContent: topicList[index].topic,
                                            textColor: Colors.white,
                                            fontSize: 15,
                                          ),
                                        )
                                      : Container(
                                          alignment: Alignment.centerLeft,
                                          child: CustomText(
                                            textContent: topicList[index].topic,
                                            textColor: Colors.grey,
                                            fontSize: 14,
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
                            child: Text('Wait fetch viwe'),
                          );
                        } else if (state is NewsLoading) {
                          return const SizedBox(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            child: ShimmerBox(),
                          );
                        } else if (state is NewsLoaded) {
                          return ListView.builder(
                            itemCount: state.articles.length,
                            itemBuilder: (context, index) {
                              final news = state.articles[index];
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.newsDetail,
                                        arguments: news);
                                  },
                                  child: index == 0
                                      ? NewsHeaderView(news.image, news.title)
                                      : BlocProvider(
                                          create: (context) => ImageCubit(),
                                          child: SizedBox(
                                            width: screenWidth,
                                            child: NewsCellView(news.image,
                                                news.title, news.publishedAt),
                                          )));
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
            )));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   super.dispose();
  // }

  Future<void> fetchUserImage() async {
    try {
      final userid = await SharedPreferencesHelper.getString('userId');
      final user = await mongodb.getuserdocument(userid, ConnectDbName.user);
      setState(() {
        user != null ? googleurl = user.photoUrl : googleurl = '';
      });
    } catch (error) {
      debugPrint('Failed to sign in with Google: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    //  StatusBar.color(const Color(0xFF00FF00));

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.blueGrey.withOpacity(0.8), // , // 設置狀態列背景為透明
      statusBarIconBrightness: Brightness.light, // 設置狀態列文字顏色為深色
    ));

    fetchUserImage();
    _newsBloc = context.read<NewsBloc>();
    _newsBloc.add(FetchArtcle());
    _headerTopic.topicListProperty();
    _focusNode.addListener(() {});
  }

  void _onFocusChanged() {
    // 当TextField失去焦点时触发的操作
    if (!_focusNode.hasFocus) {
      // 隐藏键盘
      FocusScope.of(context).unfocus();
    }
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
