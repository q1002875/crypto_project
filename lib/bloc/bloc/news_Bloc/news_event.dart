part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
  @override
  List<Object> get props => [];
}
class FetchArtcle extends NewsEvent {}

// ignore: must_be_immutable
class SearchArtcle extends NewsEvent {
  String quree;
  SearchArtcle(this.quree);
}
