part of 'cyrpto_view_bloc_bloc.dart';

abstract class CyrptoViewBlocEvent extends Equatable {
  const CyrptoViewBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchCryptoProcess extends CyrptoViewBlocEvent {}
