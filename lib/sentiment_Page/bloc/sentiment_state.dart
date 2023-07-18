part of 'sentiment_bloc.dart';

class SentimentErro extends SentimentState {}

class SentimentInitial extends SentimentState {}

class SentimentLoaded extends SentimentState {
  final List<FearGreedIndex> feargreedindex;
  const SentimentLoaded({required this.feargreedindex});

  @override
  List<Object> get props => [feargreedindex];
}

class SentimentLoading extends SentimentState {}

abstract class SentimentState extends Equatable {
  const SentimentState();

  @override
  List<Object> get props => [];
}
