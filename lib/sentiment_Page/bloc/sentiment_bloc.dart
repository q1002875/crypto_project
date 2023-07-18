import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../sentiment_api_model_file/sentiment_api.dart';
import '../sentiment_api_model_file/sentiment_model.dart';

part 'sentiment_event.dart';
part 'sentiment_state.dart';

class SentimentBloc extends Bloc<SentimentEvent, SentimentState> {
  SentimentBloc() : super(SentimentInitial()) {
    on<SentimentEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is FetchFearData) {
        emit(SentimentLoading());

        List<FearGreedIndex> feargreedindex =
            await SentimentApi.fetchFearGreedIndex(event.day);

        if (feargreedindex.isNotEmpty) {
          emit(SentimentLoaded(feargreedindex: feargreedindex));
        } else {
          emit(const SentimentLoaded(feargreedindex: []));
        }
      }
    });
  }
}
