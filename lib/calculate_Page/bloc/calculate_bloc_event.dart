part of 'calculate_bloc_bloc.dart';

abstract class CalculateBlocEvent extends Equatable {
  const CalculateBlocEvent();

  @override
  List<Object> get props => [];
}

class FetchInitData extends CalculateBlocEvent {}

class FlashCoinPrice extends CalculateBlocEvent {}

// ignore: must_be_immutable
class PressButton extends CalculateBlocEvent {
  String input;
  PressButton(this.input);
}

// ignore: must_be_immutable
class PressChangeCoin extends CalculateBlocEvent {
  String item;
  BuildContext context;
  PressChangeCoin(this.context, this.item);
}

class UpdownCoin extends CalculateBlocEvent {}
