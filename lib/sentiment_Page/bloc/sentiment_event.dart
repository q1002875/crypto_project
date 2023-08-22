part of 'sentiment_bloc.dart';

// ignore: must_be_immutable
class FetchFearData extends SentimentEvent {
  String day;
  SentimentStatus status;
  FetchFearData(this.day, this.status);
}
// class FetchChartData extends SentimentEvent {
//   String day;
//   FetchChartData(this.day);
// }

abstract class SentimentEvent extends Equatable {
  const SentimentEvent();

  @override
  List<Object> get props => [];
}

enum SentimentStatus {
  fearAndGreedIndex,
  fearAndGreedChart,
}



// class SearchArtcle extends NewsEvent {
//   String quree;
//   SearchArtcle(this.quree);
// }