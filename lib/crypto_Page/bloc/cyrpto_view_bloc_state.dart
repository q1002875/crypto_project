part of 'cyrpto_view_bloc_bloc.dart';

class CyrptoViewBlocError extends CyrptoViewBlocState {}

class CyrptoViewBlocInitial extends CyrptoViewBlocState {}

class CyrptoViewBlocLoaded extends CyrptoViewBlocState {
  final List<SymbolCase> tickData;
  final cryptoPrcess data;
  const CyrptoViewBlocLoaded({required this.data, required this.tickData});
  @override
  List<Object> get props => [tickData];
}

class CyrptoViewBlocLoading extends CyrptoViewBlocState {}

abstract class CyrptoViewBlocState extends Equatable {
  const CyrptoViewBlocState();

  @override
  List<Object> get props => [];
}



  // final List<ArticleModel> articles;

  // const NewsLoaded({required this.articles});

  // @override
  // List<Object> get props => [articles];