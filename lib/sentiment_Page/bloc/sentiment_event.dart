part of 'sentiment_bloc.dart';

// ignore: must_be_immutable
class FetchFearData extends SentimentEvent {
  String day;
  FetchFearData(this.day);
}

abstract class SentimentEvent extends Equatable {
  const SentimentEvent();

  @override
  List<Object> get props => [];
}

// class SearchArtcle extends NewsEvent {
//   String quree;
//   SearchArtcle(this.quree);
// }