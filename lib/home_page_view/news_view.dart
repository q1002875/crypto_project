import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/news_bloc.dart';
import '../cubit/image_cubit_cubit.dart';
import '../extension/custom_page_route.dart';
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

  @override
  void initState() {
    super.initState();
    _newsBloc = context.read<NewsBloc>();
    _newsBloc.add(FetchArtcle());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchArticles(String query) {
    _newsBloc.add(SearchArtcle(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                      // _searchController.clear();
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
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
                              builder: (_) => NewsDetail( news:news,)
                            ));
                        },
                        child: index == 0
                          ? NewsHeaderView(news.image, news.title)
                          : BlocProvider(
                              create: (context) => ImageCubit(),
                              child: NewsCellView(news.image, news.title,news.publishedAt))
                    );
                      
                      
                      
                    
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
    );
  }
}
