import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'news_bloc.dart';

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
        title: const Text('News'),
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
                    // _searchController.clear();
                    // _searchArticles('');
                    if (_searchController.text != "") {
                      _searchArticles(_searchController.text);
                    }
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
                      return ListTile(
                        title: Text(news.title),
                        subtitle: Text(news.description),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _searchArticles(_searchController.text);
      //   },
      //   child: const Icon(Icons.search),
      // ),
    );
  }
}
