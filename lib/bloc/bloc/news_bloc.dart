import 'package:bloc/bloc.dart';
import 'package:crypto_project/api_model/news_totalModel.dart';
import 'package:crypto_project/news_api.dart';
import 'package:equatable/equatable.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {

  final newsApi news ;
  NewsBloc(this.news) : super(NewsInitial()) {
    on<NewsEvent>((event, emit) async {

       if (event is FetchArtcle){
        emit(NewsLoading());
        try {
          final arts = await news.getArticleReport('crypto');
          emit(NewsLoaded(articles: arts));
        } catch (_) {
          emit(NewsError());
        }

       }else if (event is SearchArtcle){
        emit(NewsLoading());
        try {
          final arts = await news.getArticleReport(event.quree);
          emit(NewsLoaded(articles: arts));
        } catch (_) {
          emit(NewsError());
        }
        
       }else{
        return;
       }
    });
  }
}
