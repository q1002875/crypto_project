import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../sentiment_api_model_file/sentiment_api.dart';
import '../sentiment_api_model_file/sentiment_model.dart';

part 'sentiment_event.dart';
part 'sentiment_state.dart';

// enum SentimentStatus {
//   fearAndGreedIndex,
//   fearAndGreedChart,
// }

class SentimentBloc extends Bloc<SentimentEvent, SentimentState> {
  SentimentBloc() : super(SentimentInitial()) {
    on<SentimentEvent>((event, emit) async {
      // TODO: implement event handler
      if (event is FetchFearData) {
        emit(SentimentLoading());

        switch (event.status) {
          case SentimentStatus.fearAndGreedIndex:
            List<FearGreedIndex> feargreedindex =
                await SentimentApi.fetchFearGreedIndex(event.day);
            if (feargreedindex.isNotEmpty) {
              emit(SentimentLoaded(feargreedindex: feargreedindex));
            } else {
              emit(const SentimentLoaded(feargreedindex: []));
            }
            break;
          case SentimentStatus.fearAndGreedChart:
            List<FearGreedIndex> feargreedindex =
                await SentimentApi.fetchFearGreedIndex(event.day);
            if (feargreedindex.isNotEmpty) {
              emit(SentimentLoaded(feargreedindex: feargreedindex));
            } else {
              emit(const SentimentLoaded(feargreedindex: []));
            }
            break;
        }
      }
    });
  }
}
