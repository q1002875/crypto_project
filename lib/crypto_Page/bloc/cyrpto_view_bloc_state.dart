part of 'cyrpto_view_bloc_bloc.dart';

class CyrptoViewBlocError extends CyrptoViewBlocState {}

class CyrptoViewBlocInitial extends CyrptoViewBlocState {}

class CyrptoViewBlocLoaded extends CyrptoViewBlocState {
  final List<SymbolCase> tickData;
  final CryptoPrecess data;
  const CyrptoViewBlocLoaded({required this.data, required this.tickData});

  @override
  List<Object> get props => [data, tickData];
}

class CyrptoViewBlocLoading extends CyrptoViewBlocState {}

abstract class CyrptoViewBlocState extends Equatable {
  const CyrptoViewBlocState();

  @override
  List<Object> get props => [];
}
